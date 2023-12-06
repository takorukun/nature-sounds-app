# 作品名:NatureSoundsWithMeditaion

NatureSoundsWithMeditaionは時間がない人へ短時間で、どこでも瞑想ができることをコンセプトにしたアプリケーションです。

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
<img width="680" height="520" alt="Topページ.screenshot" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/999ec28c-4d84-4dac-9878-40d88daf3645">

### 瞑想記録機能
* 瞑想を記録することができます。
<img width="397" height="270" alt="瞑想記録機能.gif" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/e3211684-0cc6-46e8-8059-ec6368a65ff9">

### 動画投稿機能
* Youtube上の動画を共有することができます。
<img width="397" height="270" alt="動画投稿機能.gif" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/ee442762-ffc6-4d0a-9e4c-a4b6d806af6b">

### 動画検索機能
* 自身の気分によってタグを選択し、検索することができます。
<img width="397" height="270" alt="動画検索機能.gif" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/db3f7955-23ad-48f5-9f3b-1e719830b370">

### 動画再生機能
* 瞑想以外に作業用BGMとして動画を使用することができます。
<img width="397" height="270" alt="動画再生機能.gif" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/c6afbf5b-401b-4f23-81a6-907bde4940e3">

### 動画お気に入り登録機能
* 動画をお気に入り登録し一覧表示できます。
<img width="397" height="270" alt="動画お気に入り登録機能.gif" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/ff1e5aa4-474f-4699-bec3-430f1dd2bf20">

# 機能一覧

<table>
 <tbody>
  <tr>
    <th>機能名</th>
    <th>説明</th>
  </tr>
  <tr>
    <td>ログイン（ゲストログイン可能）</td>
    <td>サインアップ・ログイン・ログアウト</td>
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
    <td>瞑想を記録することができます。</td>
  </tr>
    <tr>
    <td>動画お気に入り登録・削除機能</td>
    <td>動画お気に入り登録・削除できます。</td>
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
    <td>投稿動画管理機能</td>
    <td>投稿動画情報を編集できます。</td>
  </tr>
 </tbody>
</table>

# ER図
<img width="45%" alt="ER図" src="https://github.com/takorukun/nature-sounds-with-meditation-app/assets/121709040/8f959fd3-dfd1-4509-96b7-41dad13ff063">

### 開発の経緯

私は新しいことに挑戦し、長期的に継続する力を付けたいと考えていました。</br>
調べていくうちに瞑想が効果的であることを知りました。
* 習慣化したことにより以下の能力に向上が見られました。
  * 集中力の向上
  * メンタル面の向上
  * 記憶力の向上
  * 誠実性の向上

瞑想を通して勉強の効率を高めれていると実感したため</br>
他の方にもこのアプリを通して瞑想を習慣化し、勉強の効率向上を実感して欲しいと思いこのアプリケーションを作成しました。

### 今後の課題
* ログイン認証をFirebaseでの実装
* セキュリティー懸念のためプライベートサブネットへRDSを配置
* フロントエンドにReactを使用しSPA化の実現
* ユーザー同士のフォロー機能を実装しユーザーの瞑想記録を共有できる機能を実装
* Nginxのアセットプリコンパイルを実現
* Gitの使い方の改善
  * コミットメッセージの意図を明確化
  * ブランチの細分化
