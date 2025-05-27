# 🧪 RSpec ユーザーログインテスト手順書

## 🎯 概要
Deviseを使用したユーザーログイン機能のテストを、RSpecとFactoryBotを使って実装する手順書です。
モデルテスト、コントローラーテスト、統合テストの3つの観点からテストを作成します。

## ✅ 現在の状況確認
- ✅ RSpecが設定済み
- ✅ FactoryBotが使用可能
- ✅ Deviseが導入済み
- ✅ Userモデルが作成済み
- ❌ ログイン関連のテストが未作成

## 📁 作成が必要なファイル一覧

### 🔧 **設定ファイル**
- `spec/rails_helper.rb` - RSpecの基本設定
- `spec/spec_helper.rb` - RSpecの共通設定
- `spec/support/login_helpers.rb` - ログイン用ヘルパーメソッド

### 🏭 **FactoryBotファイル**
- `spec/factories/users.rb` - Userモデルのテストデータ作成

### 🧪 **テストファイル**
- `spec/models/user_spec.rb` - Userモデルのテスト
- `spec/requests/users/sessions_spec.rb` - ログインコントローラーのテスト
- `spec/system/user_sessions_spec.rb` - ログイン機能の統合テスト

### 📦 **ディレクトリ構造**
```
spec/
├── rails_helper.rb
├── spec_helper.rb
├── support/
│   └── login_helpers.rb
├── factories/
│   └── users.rb
├── models/
│   └── user_spec.rb
├── requests/
│   └── users/
│       └── sessions_spec.rb
└── system/
    └── user_sessions_spec.rb
```

## 🚀 実装手順

### 1. 必要なGemの追加

```ruby
# Gemfile
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
```

### 2. spec_helper.rbの作成

```ruby
# spec/spec_helper.rb
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
```

### 3. RSpecの設定ファイル作成

```ruby
# spec/rails_helper.rb
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  
  # FactoryBotの設定
  config.include FactoryBot::Syntax::Methods
  
  # Deviseのテストヘルパーを含める
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
end
```

### 4. FactoryBotでUserファクトリーの作成

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    nickname              { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              { 'password123' }
    password_confirmation { 'password123' }
    last_name             { '山田' }
    first_name            { '太郎' }
    last_name_kana        { 'ヤマダ' }
    first_name_kana       { 'タロウ' }
    birthday              { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end
```

### 5. Userモデルのテスト（認証関連）

```ruby
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー新規登録' do
    before do
      @user = build(:user)
    end

    context '新規登録できる場合' do
      it '全ての項目が正しく入力されていれば登録できる' do
        expect(@user).to be_valid
      end
    end

    context '新規登録できない場合' do
      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('ニックネームを入力してください')
      end

      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールを入力してください')
      end

      it '重複したemailが存在する場合は登録できない' do
        @user.save
        another_user = build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Eメールはすでに存在します')
      end

      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードを入力してください')
      end

      it 'passwordが5文字以下では登録できない' do
        @user.password = '12345'
        @user.password_confirmation = '12345'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
      end

      it 'passwordとpassword_confirmationが不一致では登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '1234567'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end

      it 'passwordが半角英数字混合でなければ登録できない' do
        @user.password = '123456'
        @user.password_confirmation = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは半角英数字混合で入力してください')
      end
    end
  end

  describe 'ユーザー認証' do
    let(:user) { create(:user) }

    it '正しいメールアドレスとパスワードでログインできる' do
      expect(user.valid_password?('password123')).to be true
    end

    it '間違ったパスワードではログインできない' do
      expect(user.valid_password?('wrongpassword')).to be false
    end
  end
end
```

### 6. Sessions（ログイン）コントローラーのテスト

```ruby
# spec/requests/users/sessions_spec.rb
require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/sign_in" do
    it "ログインページが正常に表示される" do
      get new_user_session_path
      expect(response).to have_http_status(200)
      expect(response.body).to include('ログイン')
    end
  end

  describe "POST /users/sign_in" do
    context "正しい認証情報の場合" do
      it "ログインが成功する" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: user.password
          }
        }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context "間違った認証情報の場合" do
      it "ログインが失敗する" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: 'wrongpassword'
          }
        }
        expect(response).to have_http_status(422)
        expect(response.body).to include('メールアドレスまたはパスワードが違います')
      end
    end

    context "存在しないメールアドレスの場合" do
      it "ログインが失敗する" do
        post user_session_path, params: {
          user: {
            email: 'nonexistent@example.com',
            password: 'password123'
          }
        }
        expect(response).to have_http_status(422)
        expect(response.body).to include('メールアドレスまたはパスワードが違います')
      end
    end
  end

  describe "DELETE /users/sign_out" do
    before do
      sign_in user
    end

    it "ログアウトが成功する" do
      delete destroy_user_session_path
      expect(response).to have_http_status(303)
      expect(response).to redirect_to(root_path)
    end
  end
end
```

### 7. システムテスト（統合テスト）

```ruby
# spec/system/user_sessions_spec.rb
require 'rails_helper'

RSpec.describe "ユーザーログイン", type: :system do
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
  end

  describe "ログイン機能" do
    context "正しい認証情報でログインする場合" do
      it "ログインが成功し、トップページにリダイレクトされる" do
        # ログインページにアクセス
        visit new_user_session_path

        # フォームに入力
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password

        # ログインボタンをクリック
        click_button 'ログイン'

        # ログイン成功の確認
        expect(current_path).to eq(root_path)
        expect(page).to have_content(user.nickname)
        expect(page).to have_link('ログアウト')
        expect(page).not_to have_link('ログイン')
        expect(page).not_to have_link('新規登録')
      end
    end

    context "間違った認証情報でログインする場合" do
      it "ログインが失敗し、エラーメッセージが表示される" do
        # ログインページにアクセス
        visit new_user_session_path

        # 間違った情報を入力
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: 'wrongpassword'

        # ログインボタンをクリック
        click_button 'ログイン'

        # ログイン失敗の確認
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('メールアドレスまたはパスワードが違います')
        expect(page).to have_link('ログイン')
        expect(page).to have_link('新規登録')
      end
    end

    context "空の情報でログインする場合" do
      it "ログインが失敗し、エラーメッセージが表示される" do
        # ログインページにアクセス
        visit new_user_session_path

        # 空の情報でログインボタンをクリック
        click_button 'ログイン'

        # ログイン失敗の確認
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('メールアドレスまたはパスワードが違います')
      end
    end
  end

  describe "ログアウト機能" do
    before do
      sign_in user
      visit root_path
    end

    it "ログアウトが成功し、ログイン前の状態に戻る" do
      # ログアウトリンクをクリック
      click_link 'ログアウト'

      # ログアウト成功の確認
      expect(current_path).to eq(root_path)
      expect(page).to have_link('ログイン')
      expect(page).to have_link('新規登録')
      expect(page).not_to have_content(user.nickname)
      expect(page).not_to have_link('ログアウト')
    end
  end

  describe "認証が必要なページへのアクセス" do
    it "未ログイン状態では認証が必要なページにアクセスできない" do
      # 認証が必要なページにアクセス（例：ユーザー編集ページ）
      visit edit_user_registration_path

      # ログインページにリダイレクトされることを確認
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('アカウント登録もしくはログインしてください')
    end
  end
end
```

### 8. ヘルパーメソッドの作成

```ruby
# spec/support/login_helpers.rb
module LoginHelpers
  def login_as(user)
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'ログイン'
  end

  def logout
    click_link 'ログアウト'
  end
end

RSpec.configure do |config|
  config.include LoginHelpers, type: :system
end
```

### 9. テストの実行コマンド

```bash
# 全てのテストを実行
bundle exec rspec

# 特定のファイルのテストを実行
bundle exec rspec spec/models/user_spec.rb

# 特定のテストを実行
bundle exec rspec spec/models/user_spec.rb:10

# ログイン関連のテストのみ実行
bundle exec rspec spec/requests/users/sessions_spec.rb
bundle exec rspec spec/system/user_sessions_spec.rb

# カバレッジ付きでテスト実行
COVERAGE=true bundle exec rspec
```

### 10. テスト結果の確認ポイント

#### ✅ **成功すべきテスト**
- 正しい認証情報でのログイン
- ログイン後のリダイレクト
- ログイン状態の確認
- ログアウト機能

#### ❌ **失敗すべきテスト**
- 間違ったパスワードでのログイン
- 存在しないメールアドレスでのログイン
- 空の情報でのログイン
- 未ログイン状態での認証必要ページアクセス

### 11. デバッグのコツ

```ruby
# テスト中にブラウザを開いてデバッグ
it "ログインテスト" do
  save_and_open_page  # ページを保存してブラウザで開く
  binding.pry         # デバッガーで停止
end

# ログの確認
puts page.html        # HTMLの内容を出力
puts current_path     # 現在のパスを出力
puts page.body        # ページの内容を出力
```

## 🎯 実行順序

1. **Gemの追加とbundle install**
2. **必要なディレクトリの作成**
   ```bash
   mkdir -p spec/support
   mkdir -p spec/factories
   mkdir -p spec/requests/users
   mkdir -p spec/system
   ```
3. **設定ファイルの作成**
   - `spec/spec_helper.rb`
   - `spec/rails_helper.rb`
4. **FactoryBotでUserファクトリー作成**
   - `spec/factories/users.rb`
5. **ヘルパーメソッドの作成**
   - `spec/support/login_helpers.rb`
6. **モデルテストの実装**
   - `spec/models/user_spec.rb`
7. **リクエストテストの実装**
   - `spec/requests/users/sessions_spec.rb`
8. **システムテストの実装**
   - `spec/system/user_sessions_spec.rb`
9. **テストの実行と確認**

## 💡 ポイント

- **段階的にテスト**：モデル → コントローラー → 統合テストの順で実装
- **エラーケースも重要**：正常系だけでなく異常系のテストも必須
- **実際のユーザー操作を再現**：システムテストでは実際の操作フローをテスト
- **テストデータの管理**：FactoryBotを使って一貫性のあるテストデータを作成

## 📋 **作成チェックリスト**

### ✅ **必須ファイル作成確認**
- [ ] `spec/spec_helper.rb`
- [ ] `spec/rails_helper.rb`
- [ ] `spec/support/login_helpers.rb`
- [ ] `spec/factories/users.rb`
- [ ] `spec/models/user_spec.rb`
- [ ] `spec/requests/users/sessions_spec.rb`
- [ ] `spec/system/user_sessions_spec.rb`

### ✅ **ディレクトリ作成確認**
- [ ] `spec/support/`
- [ ] `spec/factories/`
- [ ] `spec/requests/users/`
- [ ] `spec/system/`

### ✅ **Gem追加確認**
- [ ] `rspec-rails`
- [ ] `factory_bot_rails`
- [ ] `faker`
- [ ] `capybara`
- [ ] `selenium-webdriver`
- [ ] `webdrivers`

頑張ってテストを実装していきましょう！🚀✨
