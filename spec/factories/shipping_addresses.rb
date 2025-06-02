FactoryBot.define do
  factory :shipping_address do
    post_number { '123-4567' }
    prefecture_id { 1 }
    city { '東京都' }
    street { '1-1' }
    building { '東京ハイツ' }
    phone_number { '09012345678' }
    order { association :order }
    payjp_token { 'tok_abcdefghijk00000000000000000' }
    number_form { '4242424242424242' }
    expiry_form { '1225' }
    cvc_form { '123' }
  end
end
