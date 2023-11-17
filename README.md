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
<img width="45%" alt="インフラ構成図" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/48b39b89-eccf-4e9e-bd52-bf040621fb84">

# 主な機能
### Topページ
* Topページから主要な機能をすぐに試すことができます。
<img width="680" height="520" alt="スクリーンショット 2023-11-16 22 54 16" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/d250ab9f-84b2-4b82-b643-9a5c712c4686">

### 瞑想記録機能
* 瞑想を記録することができます。
<img width="397" height="270" alt="瞑想記録機能.gif" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/66b6f562-a9a0-4488-9f59-bcb5c825b411">

### 動画投稿機能
* Youtube上の動画を共有することができます。
<img width="397" height="270" alt="動画投稿機能.gif" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/ad8cbecf-8fb1-4048-9aaf-c98855612efb">

### 動画検索機能
* 自身の気分によってタグを選択し、検索することができます。
<img width="397" height="270" alt="動画検索機能.gif" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/3e441327-cdc2-4a1c-a4cd-1df44bf57d89">

### 動画再生機能
* 瞑想以外の作業用BGMとして動画を使用することができます。
<img width="397" height="270" alt="動画再生機能.gif" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/4cd6396b-56c9-41e1-b5a5-b446d6258185">

# 機能一覧

<table>
 <tbody>
  <tr>
    <th>機能名</th>
    <th>説明</th>
  </tr>
  <tr>
    <td>ログイン（ゲストログイン可能）</td>
    <td>サインアップ・サイインイン・ログアウト</td>
  </tr>
  <tr>
    <td>動画検索機能</td>
    <td>動画を名前およびタグ検索することができます。</td>
  </tr>
  <tr>
    <td>動画再生機能</td>
    <td>動画を選択し再生することができます。</td>
  </tr>
  <tr>
    <td>動画投稿機能</td>
    <td>Youtubeの動画URLを使用し動画を共有できます。</td>
  </tr>
  <tr>
    <td>瞑想記録機能</td>
    <td>サインアップ・サイインイン・ログアウト</td>
  </tr>
  <tr>
    <td>プロフィール管理機能</td>
    <td>プロフィール情報を編集できます。</br>ゲストユーザーでは現状実装していません。</td>
  </tr>
  <tr>
    <td>瞑想記録管理機能</td>
    <td>瞑想記録情報を編集できます。</td>
  </tr>
  <tr>
    <td>投稿動画管理機能(CRUD処理)</td>
    <td>投稿動画情報を編集できます。</td>
  </tr>
 </tbody>
</table>

# ER図
<img width="35%" alt="ER図" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/246c0715-7c2e-4e03-a681-d8512c4bd4a5">

### 開発の経緯

まず私は新しいことに挑戦し、長期的に継続する力を付けたいと考えていました。
* そこでまず瞑想を選んだのは以下の理由からです。
  * 集中力の向上
  * メンタル面の向上
  * 記憶力の向上
  * 誠実性の向上

初めの内はモチベーションを保つことができ習慣化を達成しました。
その後、時間が取れない日が続くと瞑想に対するハードルが上がってしまい、習慣化が途切れてしまいました。
記録しゲーム化することでモチベーションも保ちやすくなると思い至りこのアプリケーションを作成しました。

### 今後の課題
* ログイン認証をFirebaseでの実装
* セキュリティー懸念のためプライベートサブネットへRDSを配置
* フロントエンドにReactを使用しSPA化の実現
* ユーザー同士のフォロー機能を実装しユーザーの瞑想記録を共有できる機能を実装
* Nginxのアセットプリコンパイルを実現
* 動画を投稿した際に生じる動画表示のレイアウトの乱れの修正
* トップページ以外のレスポンシブ対応の実現
* Gitの使い方の改善
  * コミットメッセージの意図を明確化
  * ブランチの細分化
