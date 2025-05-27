# 📋 Devise（デバイス）導入手順書

## 🎯 概要
Devise（デバイス）は、Railsアプリケーションでユーザー認証機能を簡単に実装できるgemです。
ログイン、ログアウト、新規登録、パスワードリセットなどの機能を提供します。

## ✅ 現在の状況
- ✅ Gemfileにdeviseが追加済み
- ✅ devise.rbの設定ファイルが存在
- ❌ Userモデルがまだ未作成
- ❌ マイグレーションファイルが未実行
- ❌ ルーティングの設定が未完了

## 🚀 実装手順

### 1. Deviseの初期設定
```bash
# deviseの設定ファイルを生成（既に完了済み）
rails generate devise:install
```

### 2. Userモデルの生成
```bash
# Userモデルとマイグレーションファイルを生成
rails generate devise User
```

### 3. マイグレーションファイルの編集
生成されたマイグレーションファイルに以下のカラムを追加：

```ruby
# db/migrate/[timestamp]_devise_create_users.rb
class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## 追加するカラム
      t.string :nickname,           null: false
      t.string :last_name,          null: false
      t.string :first_name,         null: false
      t.string :last_name_kana,     null: false
      t.string :first_name_kana,    null: false
      t.date   :birth_date,         null: false

      ## Recoverable
      # t.string   :reset_password_token
      # t.datetime :reset_password_sent_at

      ## Rememberable
      # t.datetime :remember_created_at

      ## Trackable
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    # add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
```

### 4. Userモデルの設定
```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーション
  validates :nickname, presence: true
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true
  validates :first_name_kana, presence: true
  validates :birth_date, presence: true
end
```

### 5. ルーティングの設定
```ruby
# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  root to: "items#index"
  resources :items, only: [:index]
end
```

### 6. マイグレーションの実行
```bash
# データベースにテーブルを作成
rails db:migrate
```

### 7. ApplicationControllerの設定
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_date])
  end
end
```

### 8. ビューファイルの生成（必要に応じて）
```bash
# deviseのビューファイルをカスタマイズしたい場合
rails generate devise:views
```

### 9. ヘッダーの修正
```erb
<!-- app/views/shared/_header.html.erb -->
<ul class='lists-right'>
  <% if user_signed_in? %>
    <li><%= link_to current_user.nickname, "#", class: "user-nickname" %></li>
    <li><%= link_to 'ログアウト', destroy_user_session_path, data: {turbo_method: :delete}, class: "logout" %></li>
  <% else %>
    <li><%= link_to 'ログイン', new_user_session_path, class: "login" %></li>
    <li><%= link_to '新規登録', new_user_registration_path, class: "sign-up" %></li>
  <% end %>
</ul>
```

## 🔧 主要なdeviseのヘルパーメソッド

### 認証関連
- `user_signed_in?` - ユーザーがログインしているかチェック
- `current_user` - 現在ログインしているユーザーを取得
- `authenticate_user!` - ログインを強制（未ログインの場合はログインページにリダイレクト）

### パス関連
- `new_user_registration_path` - 新規登録ページ
- `new_user_session_path` - ログインページ
- `destroy_user_session_path` - ログアウト
- `edit_user_registration_path` - ユーザー情報編集ページ

## 🎨 次のステップ
1. ✅ 上記手順を順番に実行
2. 🎯 ビューファイルのカスタマイズ
3. 🔒 セキュリティ設定の強化
4. 📧 メール機能の設定（パスワードリセット等）

## 💡 ポイント
- deviseは多機能なので、必要な機能だけを有効にしましょう
- バリデーションはUserモデルで適切に設定しましょう
- セキュリティを考慮してstrong parametersを設定しましょう

頑張って実装していきましょう！🚀
