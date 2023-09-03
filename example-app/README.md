# Ruby on Rails

## 環境作成
`rails new <アプリ名>`コマンドで新しいアプリを作成できる。  
新しく作成されるフォルダの役割は以下の通り。


|ファイル/フォルダ名|目的|
|---|---|
|app/|アプリケーションのコントローラ、モデル、ビューなどの主要コンテンツが含まれる。|
|bin/|railsアプリの起動、セットアップに使用する実行ファイル含まれる。｜
|config/|アプリケーションのルートやデータベースなどの設定含まれる。|
|config.ru|アプリケーションの起動に使用するRackベースのサーバーの設定ファイル。|
|db/|データベーススキーマファイルとマイグレーションファイルが含まれる。|
|Gemfile / Gemfile.lock|Bundler gemで使用される、依存関係を指定するファイル。|
|lib/|アプリケーション拡張モジュールが含まれる。|
|log/|アプリケーションのログが含まれる。|
|public/|	アプリケーションの静的ファイルが含まれる。|
|Rakefile|コマンドラインから実行できるタスクを探してロードするファイル。アプリケーションのlib/tasksディレクトリに独自タスクのファイルを追加して実行する。|
|storage/|ディスクサービス用のActive Storageフォルダ。|
|test/|ユニットテストやfixtureファイルが含まれる。|
|tmp/|一時ファイル置き場。|
|vendor/|サードパーティ製のコードを配置するフォルダ。|
|.gitattributes|gitのメタデータなどを記述するファイル。|
|.gitignore|gitの管理対象から除外するファイルを記述するファイル。|
|.ruby-version|Rubyのバージョンを記述するファイル。|

## 実装

### モデルの作成

`rails g model <モデル名(アッパーキャメルケース、単数形)> <カラム名>:<データ型>`コマンドでモデルを作成する。  
例: `rails g model User name:string age:integer`

モデルを作成すると、app/model配下にモデルクラスが作成される。モデルファイルにはバリデーションやリレーションなどを記述することができる。  
また、dbフォルダ内のschema.rbファイルにデータ構造が追記され、db/migrateフォルダ内にmigrationファイルが生成される。

#### マイグレーション
`rails db:migrate`コマンドでマイグレーションできる。

マイグレーションファイルを作成するには`rails g migration <マイグレーション名>`コマンドを実行する。このコマンドではタイムスタンプが自動で付与されたマイグレーションファイルが生成される。  
マイグレーション名には特定の形式でマイグレーショ内容を記載することができる。以下の例ではproductテーブルにpart_numberカラムを追加するコードが自動生成される。  
コマンド例: `rails g migration AddPartNumberToProducts part_number:string`  
ファイル名: `YYYYMMDDHHMMSS_add_part_number_to_products.rb`  
生成されるコード: 
```ruby
class AddPartNumberToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :part_number, :string
  end
end
```

### コントローラの作成

`rails g controller <コントローラ名(アッパーキャメルケース、複数形)>`コマンドで作成できる。
例: `rails g controller Users`

#### ルーティングについて

ルーティングはconfig/routes.rb内に記載する。  
ルーティングは上から適用され、最初にマッチしたルートにルーティングされる。

ルーティングの記載フォーマットは以下の通り  
`<HTTPメソッド> '<パス、パラメータ>', to: '<コントローラ名(スネークケース)>#<メソッド>'`

例: `get '/patients/:id', to: 'patients#show'`

例の場合、/patients/1にGETリクエストが来るとPatientsコントローラのshowメソッドが呼ばれる。

また、一般的なCRUD操作を行うコントローラの場合、リソースベースルーティングが使用できる。

resourcesルーティングのフォーマットは以下の通り
`resources :<コントローラ名(スネークケース)>`

例: `resources :photos`

リソースルーティングではCRUDの各操作が特定のメソッド名に自動的にルーティングされる。操作とメソッド名の対応は以下の表のとおり。

|HTTPメソッド|パス|実行されるメソッド|目的|
|-|-|-|-|
|GET|/photos|photos#index|すべての写真の一覧を表示|
|GET|/photos/new|photos#new|写真を1つ作成するためのHTMLフォームを返
|POST|/photos|photos#create|写真を1つ作成する|
|GET|/photos/:id|photos#show|特定の写真を表示する|
|GET|/photos/:id/edit|photos#edit|写真編集用のHTMLフォームを1つ返す|
|PATCH / PUT|/photos/:id|photos#update|特定の写真を更新する|
|DELETE|/photos/:id|photos#destroy|特定の写真を削除する|

リソースベースルーティングを利用すると便利なヘルパー関数を利用できる。_pathヘルパーの対応表を以下に示す。

|パス|ヘルパー関数|
|/posts| posts_path|
|/posts/new|new_post_path|
|/posts/:id/edit|edit_post_path(:id)|
|/posts/:id|post_path(:id)|

使用例: `<%= link_to 'show', post_path(post) %>`

リダイレクトするときは_urlヘルパーを利用する。_urlヘルパーはフルパスを返す。

使用例: `redirect_to post_url(@post)`

また、上記は以下のようにも書ける。  
`redirect_to @post`

