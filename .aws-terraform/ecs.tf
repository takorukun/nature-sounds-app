data "aws_ssm_parameter" "db_host" {
  name = "db_host"
}

data "aws_ssm_parameter" "nginx_ecr_repo_uri" {
  name = "nginx_ecr_repo_uri"
}

data "aws_ssm_parameter" "rails_ecr_repo_uri" {
  name = "rails_ecr_repo_uri"
}

resource "aws_ecs_cluster" "nature_sounds_cluster" {
  name = "nature_sounds_prod_cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "task_family"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.execution_role_arn

  container_definitions = <<DEFINITION
  [
    {
      "name": "rails",
      "image": "${data.aws_ssm_parameter.rails_ecr_repo_uri.value}",
      "cpu": 128,
      "memory": 256,
      "essential": true,
      "healthCheck": {
        "command":  ["CMD-SHELL","rails check || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 0
      },
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "ap-northeast-1",
          "awslogs-group": "awslogs-group",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "environment": [
        {
          "name": "RAILS_ENV",
          "value": "production"
        },
        {
          "name": "RDS_HOST",
          "value": "${data.aws_ssm_parameter.db_host.value}"
        },
        {
          "name": "RDS_USERNAME",
          "value": "${data.aws_ssm_parameter.db_username.value}"
        },
        {
          "name": "RDS_PASSWORD",
          "value": "${data.aws_ssm_parameter.db_password.value}"
        },
        {
          "name": "ALB_DNS_NAME",
          "value": "${aws_lb.app_alb.dns_name}"
        }
      ]
    },
    {
      "name": "nginx",
      "image": "${data.aws_ssm_parameter.nginx_ecr_repo_uri.value}",
      "cpu": 128,
      "memory": 256,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "protocol": "tcp"
        }
      ],
      "healthCheck": {
        "command":  ["CMD-SHELL","curl -f http://localhost/ || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 0
      },
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "ap-northeast-1",
          "awslogs-group": "awslogs-group",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "environment": [
        {
          "name": "ALB_DNS_NAME",
          "value": "${aws_lb.app_alb.dns_name}"
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "nature_sounds_service" {
  name            = "nature-sounds-service"
  cluster         = aws_ecs_cluster.nature_sounds_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_web_subnet1.id, aws_subnet.public_web_subnet2.id]
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "nginx"
    container_port   = 80
  }
}

resource "aws_security_group" "ecs_tasks_sg" {
  name   = "ecs_tasks_sg"
  vpc_id = aws_vpc.main_app_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_tasks_sg"
  }
}

resource "aws_security_group_rule" "ecs_tasks_sg_rule" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ecs_tasks_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_cloudwatch_log_group" "awslogs-group" {
  name              = "awslogs-group"
  retention_in_days = 7
}
