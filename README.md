## テーブル設計

### users テーブル（ユーザー）

| カラム名   | 型       | オプション       | 説明         |
|------------|----------|------------------|--------------|
| id         | integer  | primary_key      | ユーザーID   |
| name       | string   | null: false      | ユーザー名   |
| email      | string   | null: false, unique: true | メールアドレス |
| password   | string   | null: false      | パスワード   |

### items テーブル（商品）

| カラム名       | 型      | オプション       | 説明               |
|----------------|---------|------------------|--------------------|
| id             | integer | primary_key      | 商品ID             |
| name           | string  | null: false      | 商品名             |
| price          | integer | null: false      | 価格               |
| deriver_cost   | integer | null: false      | 配送料             |
| deriver_date   | string  | null: false      | 発送までの日数     |
| deriver_from   | string  | null: false      | 発送元地域         |
| state          | string  | null: false      | 商品の状態         |
| image          | string  | null: false      | 商品画像           |
| category       | string  | null: false      | カテゴリ           |
| user_id        | integer | foreign_key: true| 出品者のユーザーID |
| solid          | boolean | default: false   | 売却済みフラグ（trueで売却済） |

### purchases テーブル（購入情報）

| カラム名        | 型      | オプション       | 説明              |
|-----------------|---------|------------------|-------------------|
| id              | integer | primary_key      | 購入ID            |
| user_id         | integer | foreign_key: true| 購入者ユーザーID  |
| item_id         | integer | foreign_key: true| 購入した商品ID    |
| credit_card     | string  | null: false      | クレジットカード番号 |
| limit           | string  | null: false      | 有効期限          |
| security_code   | string  | null: false      | セキュリティコード |
| post_number     | string  | null: false      | 郵便番号          |
| prefecture      | string  | null: false      | 都道府県          |
| address1        | string  | null: false      | 市区町村          |
| address2        | string  | null: false      | 番地              |
| address3        | string  |                  | 建物名            |
| phone_number    | string  | null: false      | 電話番号          |

## アソシエーション

- User
  - has_many :items
  - has_many :purchases

- Item
  - belongs_to :user
  - has_one :purchase

- Purchase
  - belongs_to :user
  - belongs_to :item