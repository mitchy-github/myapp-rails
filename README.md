# 公共Living
## アプリ概要
数ある作品の中から、ご覧いただきありがとうございます。<br>
公共Livingは、妊娠中の方、子育て真っ只の主婦・主夫層向けに、質問、投稿、相互フォロー同士でのチャットを通して育児中の悩みや思い出を共有し、子育ての不安解消を主な目的とした一緒に子育てを楽しめる人同士が出会えるサービスとなっております。<br>
赤ちゃんの夜泣きや離乳食を食べずいつまでも食べもので遊んでる。病気やケガでないので病院には連れてけないが、誰に聞けばいいのかわからない。といった悩みに対して、元医師や看護師から何人も育てたベテランおばあちゃんまでみんなにアドバイスを聞くことができます。<br>

## アプリを作成した経緯
私は、学生時代からボランティアサークルにて活動をしていく中で、地元の商店街やショッピングモールでイベントがあった際に、子供と接する機会が多く、子どもとのやり取りやコミュニケーションに対して抵抗なく自然に接することが出来るようになったのですが、お子様がいる友人から、子どもは好きだけど接し方が分からない等の理由で相談を受けることが多かったため、公共Livingを開発することに決めました。

## URL
https://koukyouliving.com/

## 使用技術
- フロントエンド
  - Vue.js
  - Tailwind Css
- バックエンド
  - Ruby 3.1.1
  - Ruby on Rails 7.0.5
  - RuboCop
- インフラ・開発環境
  - Docker / Docker-compose
  - AWS( VPC / ECS / RDS(MySQL) / ALB / ACM / Route53 / IAM /ECR / ECSファーゲート / S3 )
  - GitHub Actions(CI/CD)
  - MySQL 8.0.29/ Puma
- テスト
  - Rspec
  - FactoryBot
- バージョン管理
  - Git/GitHub
- 開発環境
  - VScode

## 特にこだわったポイント5点
### <strong>1. プルリクベースでの開発</strong>
プルリクエストを通じて、新しいコードや変更がチームメンバーによってレビューされ、品質を向上させることができることや、バグの早期発見やコーディングスタイルの一貫性を確保できる等の利点により、プルリクエストベースの開発はチームの効率性を向上させ、コードの品質と信頼性を高めるのに役立つと考えたため導入しました。

### <strong>2. RSPEC</strong>
RSpecを使用することで、Rubyアプリケーションの品質を向上させ、バグの早期発見、アプリケーションの信頼性向上、開発プロセスの効率化などが実現できると考え使用しました。

### <strong>3. モダンな技術</strong>
Tailwind CSSならではの、コンポーネント指向のスタイリングや、UIコンポーネントを簡単に設計でき、再利用可能なスタイリングブロックを作成しやすく、コードの重複を減らせる等の柔軟性、カスタマイズ性のあるスタイリングフレームワーク。<br>
コンポーネントベースのアーキテクチャを採用したVue.jsは、コードの保守性と可読性が向上され、効率的な開発が可能なことや、シンプルで直感的なAPIとドキュメンテーションが提供されており、問題解決や質問への回答が得やすい。<br>
これらの特徴を持ったモダンな開発アプローチをしたいと考え使用しました。<br>

### <strong>4. N+1問題の解消</strong>
ストレスフリーにサービスを利用して頂く上で、高速なレスポンスは大前提でサービスの信用に直結すると考えます。 上記の問題解消に取り組むことで、DBのデータ抽出メソッド関係などSQLの基本を学べたと同時に ActiveRecordのメリット、デメリットを考察することができました。今後は多くのSQLの扱い知識を身につけていきます。

### <strong>5. CI/CD</strong>
GitHub Actionsはほぼ無料であることや、今回使用していませんがディレクトリ単位でCIをキックするか判定できる機能を持っていることからCI/CDにGitHub Actionsを使用しようと考えました。

## 機能一覧
- ユーザーに関する機能
  - ユーザー登録、ログイン、ログアウト
  - ゲストログイン機能（あらかじめ作成している情報でログイン）
  - 相互フォロー同士のチャット機能
- 質問・回答機能
  - ハッシュタグでキーワードから質問を探すことができる
  - ベストアンサー機能
- 投稿機能
  - 画像を一緒に投稿できる
  - いいね追加、取消機能

## 遷移図
<img src= '/README_images/Transition_diagram.JPEG'>

## ER図
<img src= '/README_images/ER.JPEG' >

## インフラ設計図
<img src= '/README_images/Infra.JPEG' >

<br><br>
<strong>最後までご覧いただきましてありがとうございました。</strong>
