FactoryBot.define do
  factory :item do
    name { 'テスト商品' }
    description { 'これはテスト用の商品説明です。' }
    category_id { 2 }
    state_id { 2 }
    delivery_cost_id { 2 }
    prefecture_id { 2 }
    delivery_date_id { 2 }
    price { 1000 }

    association :user

    after(:build) do |item|
      item.image.attach(
        io: File.open(Rails.root.join('test', 'fixtures', 'files', 'LGMT2.png')),
        filename: 'LGMT2.png',
        content_type: 'image/png'
      )
    end
  end
end
