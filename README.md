## 📦 テーブル設計

### 🧑‍💼 users テーブル（ユーザー情報）

| カラム名              | 型       | オプション                        | 説明                |
|---------------------|----------|-----------------------------------|-------------------|
| nickname            | string   | null: false                       | ニックネーム         |
| email               | string   | null: false, unique: true         | メールアドレス       |
| encrypted_password  | string   | null: false                       | パスワード（6文字以上の半角英数字）  |
| last_name           | string   | null: false                       | 苗字               |
| first_name          | string   | null: false                       | 名前               |
| last_name_kana      | string   | null: false                       | 苗字（カタカナ）     |
| first_name_kana     | string   | null: false                       | 名前（カタカナ）     |
| birth_year_id       | integer  | null: false                       | 誕生年             |
| birth_month_id      | integer  | null: false                       | 誕生月             |
| birth_day_id        | integer  | null: false                       | 誕生日             |

---

### 🛍 items テーブル（商品情報）

| カラム名           | 型        | オプション                     | 説明                    |
|-------------------|-----------|--------------------------------|------------------------|
| name              | string    | null: false, limit: 40         | 商品名（40文字まで）     |
| description       | text      | null: false, limit: 1000       | 商品の説明（1000文字まで）|
| price             | integer   | null: false                    | 価格（半角数字のみ）      |
| category_id       | integer   | null: false                    | カテゴリ                |
| state_id          | integer   | null: false                    | 商品の状態              |
| deliver_cost_id   | integer   | null: false                    | 配送料の負担            |
| deliver_date_id   | integer   | null: false                    | 発送までの日数          |
| prefecture_id     | integer   | null: false                    | 発送元の都道府県         |
| user              | references| null: false, foreign_key: true | 出品者                  |

---

### 💳 orders テーブル（購入記録）

| カラム名   | 型        | オプション                | 説明               |
|------------|-----------|---------------------------|--------------------|
| user       | references| null: false, foreign_key: true| 購入者         |
| item       | references| null: false, foreign_key: true| 購入された商品   |

---

### 📦 shipping_addresses テーブル（発送先情報）

| カラム名     | 型        | オプション                | 説明           |
|--------------|-----------|---------------------------|----------------|
| post_number  | string    | null: false              | 郵便番号       |
| prefecture_id| integer   | null: false              | 都道府県       |
| city         | string    | null: false              | 市区町村       |
| street       | string    | null: false              | 番地           |
| building     | string    |                          | 建物名         |
| phone_number | string    | null: false              | 電話番号       |
| order        | references| null: false, foreign_key: true| 紐づく購入記録|

---

## 🔗 アソシエーション

- **User**
  - has_many :items
  - has_many :orders
  - belongs_to_active_hash :birth_year
  - belongs_to_active_hash :birth_month
  - belongs_to_active_hash :birth_day

- **Item**
  - belongs_to :user
  - has_one :order
  - has_one_attached :image
  - belongs_to_active_hash :category
  - belongs_to_active_hash :state
  - belongs_to_active_hash :deliver_cost
  - belongs_to_active_hash :deliver_date
  - belongs_to_active_hash :prefecture

- **Order**
  - belongs_to :user
  - belongs_to :item
  - has_one :shipping_address

- **ShippingAddress**
  - belongs_to :order
  - belongs_to_active_hash :prefecture