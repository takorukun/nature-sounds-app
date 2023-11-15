# 作品名:NatureSoundsWithMeditaions

NatureSoundsWithMeditaionsは時間がない人へ短時間で、どこでも瞑想ができることをコンセプトにしたアプリケーションです。

▼サービス URL

https://nature-sounds01.com/

# 使用技術

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
<img width="45%" alt="インフラ構成図" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/4a327c13-c08a-4b74-8822-d5e774f9a409">

# 主な機能
* 動画投稿機能
* 瞑想記録機能
* 動画検索機能
* 動画再生機能

# ユーザー機能
* ログイン機能（ゲストログイン可能）
* ログアウト機能
* 瞑想記録管理機能(CRUD処理)
* ユーザ情報管理機能(CRUD処理)
* 投稿動画管理機能(CRUD処理)

# ER図
<img width="35%" alt="ER図" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/246c0715-7c2e-4e03-a681-d8512c4bd4a5">

### 開発の経緯
瞑想を習慣化したいと思っていました。
初めの内はモチベーションを保てることができ習慣化を達成しました。
その後、時間が取れない日が続くと瞑想に対するハードルが上がってしまい、習慣化が途切れてしまいました。
記録しゲーム化することでモチベーションも保ちやすくなると思い至りこのアプリケーションを作成しました。

### 今後の課題
* ログイン認証をFirebaseでの実装
* フロントエンドにReactを使用しSPA化の実現
* ユーザー同士のフォロー機能を実装しユーザーの瞑想記録を共有できる機能を実装
* Nginxのアセットプリコンパイルを実現
* 動画を投稿した際に生じる動画表示のレイアウトの乱れの修正
* トップページ以外のレスポンシブ対応の実現
* Gitの使い方の改善
  * コミットメッセージの意図を明確化
  * ブランチの細分化
