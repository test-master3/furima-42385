# 📚 プログラミング ベストプラクティス集

## 🎯 はじめに

このドキュメントは、より良いコードを書くための**ベストプラクティス**をまとめたものです。
一度にすべてを覚える必要はありません。少しずつ身につけていきましょう！

---

## 🛡️ 1. 防御的プログラミング

**意味**: エラーが起きる可能性を事前に考慮し、安全なコードを書くこと

### JavaScript
```javascript
// ❌ 危険なコード
user.name.toUpperCase()
element.addEventListener('click', handler)

// ✅ 安全なコード
if (user && user.name) {
  user.name.toUpperCase()
}

if (element) {
  element.addEventListener('click', handler)
}
```

### Ruby/Rails
```ruby
# ❌ 危険
@user.orders.first.total_price

# ✅ 安全
@user&.orders&.first&.total_price
# または
if @user && @user.orders.any?
  @user.orders.first.total_price
end
```

---

## 📝 2. 明確な命名規則

**意味**: コードを読む人が理解しやすい変数名・関数名を使う

### 悪い例
```javascript
const d = new Date()
const u = users.filter(x => x.a > 18)
const calc = (p, r) => p * r

function doStuff(data) {
  // 何をする関数か分からない
}
```

### 良い例
```javascript
const currentDate = new Date()
const adultUsers = users.filter(user => user.age > 18)
const calculateTotalPrice = (price, taxRate) => price * taxRate

function validateUserInput(userData) {
  // ユーザー入力をバリデーションする関数
}
```

### 命名のルール
- **変数**: 名詞で具体的に (`userId`, `totalAmount`)
- **関数**: 動詞で始める (`getUserById`, `calculateTax`)
- **定数**: 大文字とアンダースコア (`MAX_RETRY_COUNT`)
- **ブール値**: is/has/canで始める (`isValid`, `hasPermission`)

---

## 🔄 3. DRY (Don't Repeat Yourself)

**意味**: 同じコードを繰り返し書かず、再利用可能にする

### 悪い例
```javascript
function calculateTax1(price) {
  return price * 0.1
}
function calculateTax2(price) {
  return price * 0.1
}
function calculateTax3(price) {
  return price * 0.1
}
```

### 良い例
```javascript
function calculateTax(price, rate = 0.1) {
  return price * rate
}

// 使用例
const tax1 = calculateTax(1000)        // 10%
const tax2 = calculateTax(1000, 0.08)  // 8%
const tax3 = calculateTax(1000, 0.05)  // 5%
```

### Rails例
```ruby
# ❌ 繰り返し
class User < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end

class Admin < ApplicationRecord
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end

# ✅ 共通化
module Concerns::Emailable
  extend ActiveSupport::Concern
  
  included do
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  end
end

class User < ApplicationRecord
  include Concerns::Emailable
end
```

---

## 🧩 4. 単一責任の原則

**意味**: 一つの関数・クラスは一つの責任だけを持つ

### 悪い例
```javascript
function processUser(userData) {
  // バリデーション
  if (!userData.email) return false
  if (!userData.name) return false
  
  // データベース保存
  database.save(userData)
  
  // メール送信
  sendEmail(userData.email, 'Welcome!')
  
  // ログ出力
  console.log(`User ${userData.name} created`)
}
```

### 良い例
```javascript
function validateUser(userData) {
  return userData.email && userData.name
}

function saveUser(userData) {
  return database.save(userData)
}

function sendWelcomeEmail(email) {
  return sendEmail(email, 'Welcome!')
}

function logUserCreation(userName) {
  console.log(`User ${userName} created`)
}

// メイン処理
function processUser(userData) {
  if (!validateUser(userData)) return false
  
  const user = saveUser(userData)
  sendWelcomeEmail(user.email)
  logUserCreation(user.name)
  
  return user
}
```

---

## 💬 5. 適切なコメントとドキュメント

### コメントの書き方
```javascript
// ❌ 不要なコメント
let i = 0 // iを0に設定
user.name = 'John' // nameをJohnに設定

// ✅ 有用なコメント
// PAY.JPのテスト環境用公開キー
const payjp = Payjp('pk_test_6b883e9cc46df4dfacdb9e18')

// 税込価格を計算（消費税10%）
const taxIncludedPrice = price * 1.1

// HACK: 古いブラウザ対応のため一時的な処理
if (!Array.prototype.includes) {
  // polyfill実装
}

/**
 * ユーザーの年齢を計算する
 * @param {Date} birthDate - 生年月日
 * @returns {number} 年齢
 */
function calculateAge(birthDate) {
  // 実装...
}
```

### コメントのガイドライン
- **WHY（なぜ）** を説明する
- **WHAT（何を）** はコード自体で分かるようにする
- **複雑なロジック** の説明
- **一時的な処理** の理由
- **外部依存** の説明

---

## 🔒 6. セキュリティ重視

### SQLインジェクション対策
```ruby
# ❌ 危険
User.where("name = '#{params[:name]}'")

# ✅ 安全
User.where(name: params[:name])
User.where("name = ?", params[:name])
```

### XSS対策
```erb
<!-- ❌ 危険 -->
<%= raw user_input %>
<%= user_input.html_safe %>

<!-- ✅ 安全 -->
<%= user_input %>
<%= sanitize(user_input) %>
```

### Strong Parameters
```ruby
# ✅ 必須
def user_params
  params.require(:user).permit(:name, :email, :age)
end
```

---

## ⚡ 7. パフォーマンス配慮

### DOM操作の最適化
```javascript
// ❌ 非効率（毎回DOM操作）
for (let i = 0; i < items.length; i++) {
  document.getElementById('list').innerHTML += `<li>${items[i]}</li>`
}

// ✅ 効率的（一度だけDOM操作）
const listHtml = items.map(item => `<li>${item}</li>`).join('')
document.getElementById('list').innerHTML = listHtml
```

### データベースクエリの最適化
```ruby
# ❌ N+1問題
users = User.all
users.each do |user|
  puts user.posts.count  # 毎回クエリ実行
end

# ✅ includes使用
users = User.includes(:posts)
users.each do |user|
  puts user.posts.count  # 事前読み込み済み
end
```

---

## 🧪 8. テスタブルなコード

### 依存関係の分離
```javascript
// ❌ テストしにくい
function processOrder() {
  const data = fetchDataFromAPI()  // 外部依存
  const result = calculatePrice(data)
  saveToDatabase(result)           // 外部依存
  return result
}

// ✅ テストしやすい
function calculatePrice(data) {
  return data.price * data.quantity
}

function processOrder(data, saveFunction = saveToDatabase) {
  const result = calculatePrice(data)
  saveFunction(result)
  return result
}

// テスト例
test('calculatePrice should calculate correctly', () => {
  const data = { price: 100, quantity: 2 }
  expect(calculatePrice(data)).toBe(200)
})
```

---

## 🎯 Rails特有のベストプラクティス

### コントローラー
```ruby
# ❌ 太いコントローラー
class UsersController < ApplicationController
  def create
    # 50行のビジネスロジック...
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      UserMailer.welcome_email(@user).deliver_now
      # ...たくさんの処理
    end
  end
end

# ✅ 薄いコントローラー
class UsersController < ApplicationController
  def create
    @user = UserCreationService.new(user_params).call
    
    if @user.persisted?
      redirect_to @user, notice: 'User created successfully'
    else
      render :new
    end
  end
end
```

### サービスオブジェクト
```ruby
class UserCreationService
  def initialize(user_params)
    @user_params = user_params
  end
  
  def call
    user = User.new(@user_params)
    
    if user.save
      send_welcome_email(user)
      create_default_settings(user)
    end
    
    user
  end
  
  private
  
  def send_welcome_email(user)
    UserMailer.welcome_email(user).deliver_later
  end
  
  def create_default_settings(user)
    UserSetting.create(user: user, theme: 'light')
  end
end
```

---

## 💡 JavaScript/フロントエンド

### イベント処理
```javascript
// ❌ 直接HTML
<button onclick="deleteUser()">削除</button>

// ✅ イベントリスナー
document.getElementById('deleteBtn').addEventListener('click', deleteUser)

// ✅ さらに良い（イベント委譲）
document.addEventListener('click', (e) => {
  if (e.target.matches('.delete-btn')) {
    deleteUser(e.target.dataset.userId)
  }
})
```

### 非同期処理
```javascript
// ❌ コールバック地獄
getData(function(a) {
  getMoreData(a, function(b) {
    getEvenMoreData(b, function(c) {
      // 処理...
    })
  })
})

// ✅ Promise
getData()
  .then(a => getMoreData(a))
  .then(b => getEvenMoreData(b))
  .then(c => {
    // 処理...
  })

// ✅ async/await
async function fetchAllData() {
  try {
    const a = await getData()
    const b = await getMoreData(a)
    const c = await getEvenMoreData(b)
    return c
  } catch (error) {
    console.error('データ取得エラー:', error)
  }
}
```

---

## 🎉 学習のコツ

### 📈 段階的に身につける
1. **まず動くコードを書く** - 完璧でなくてもOK
2. **リファクタリング**で改善 - 動くコードを少しずつ改善
3. **コードレビュー**で学ぶ - 他の人からフィードバック
4. **他人のコード**を読む - GitHub等でオープンソースを読む

### 🔍 日々意識するポイント
- **読みやすさ** > 書きやすさ
- **保守性**を重視 - 半年後の自分が理解できるか
- **エラーハンドリング**を忘れずに
- **テスト**を書く習慣をつける

### 📚 学習リソース
- **書籍**: リーダブルコード、Clean Code
- **サイト**: MDN Web Docs、Rails Guides
- **練習**: 小さなプロジェクトで実践
- **コミュニティ**: Stack Overflow、Qiita

---

## 📝 まとめ

ベストプラクティスは**一度に全部覚える必要はありません**。

1つずつ意識して、**習慣化**していくことが大切です。

最初は「防御的プログラミング」から始めて、徐々に他のプラクティスも取り入れていきましょう！

**良いコードは、未来の自分と同僚への贈り物です** 🎁✨

---

*作成日: 2025年6月2日*  
*最終更新: 2025年6月2日* 