# NatureSoundsWithMeditaions

NatureSoundsWithMeditaionsは時間がない人へ短時間で、どこでも瞑想ができることをコンセプトにしたアプリケーションです。

▼サービス URL

https://nature-sounds01.com/

## 概要
### 

## 主な機能
* 動画投稿機能
* 瞑想記録機能
* 動画検索機能
* 動画再生機能

## ユーザー機能
* ログイン機能（ゲストログイン可能）
* ログアウト機能
* 瞑想記録管理機能(CRUD処理)
* ユーザ情報管理機能(CRUD処理)
* 投稿動画管理機能(CRUD処理)

## 使用技術

### フロントエンド
* HTML
* Tailwind CSS(3.3.3)
* JavaScript
* Daisy UI(3.9.2)

### バックエンド
* Ruby(3.0.5)
* Rails(7.0.6)
* コード解析 / フォーマッター: Rubocop(1.32.0)
* テストフレームワーク: RSpec(6.0.3)

### データベース
* MySQL

### インフラ
* AWS
  * Route53 / Certificate Manager / ALB / VPC / ECR / ECS Fargate / RDS MySQL / S3 / Cloud Watch / Systems Manager
* NginX(1.25.2)
* Terraform(1.0.6)

### CI/CD
* GitHub Actions

### 環境構築
* Docker(24.0.2)
* docker-compose(2.19.1)

### 外部サービス
* Youtube API

## インフラ構成図
<img width="50%" alt="インフラ構成図" src="https://github.com/takorukun/nature-sounds-app/assets/121709040/426fb8bb-2e5a-494e-8fcc-bdb880206d82">

## ER図
<img width="50%" alt="ER図" src="https://github.com/takorukun/nature-sounds-app/assets/121709040/94fb276f-a458-4dbf-9f1e-515685cbb25c">

## 今後の課題
* ログイン認証をFirebaseでの実装
* フロントエンドにReactを使用しSPA化の実現
* ユーザー同士のフォロー機能を実装しユーザーの瞑想記録を共有できる機能を実装
* Nginxのアセットプリコンパイルを実現
* 動画を投稿した際に生じる動画表示のレイアウトの乱れの修正
* トップページ以外のレスポンシブ対応の実現
