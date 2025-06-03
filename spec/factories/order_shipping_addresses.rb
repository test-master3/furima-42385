FactoryBot.define do
  factory :order_shipping_address do
    post_number { '123-4567' }
    prefecture_id { 2 }
    city { '東京都' }
    street { '1-1-1' }
    building { 'テストビル' }
    phone_number { '09012345678' }
    payjp_token { 'tok_test_token' }
    # item_idとuser_idはテストで実際のインスタンスから設定
  end
end
