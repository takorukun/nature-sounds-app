threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count
port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "production" }
plugin :tmp_restart

bind "tcp://0.0.0.0:3000"

app_root = File.expand_path("../..", __FILE__)

stdout_redirect "#{app_root}/log/puma.stdout.log", "#{app_root}/log/puma.stderr.log", true
