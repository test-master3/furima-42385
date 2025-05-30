FactoryBot.define do
  factory :shipping_address do
    post_number { "MyString" }
    prefecture_id { 1 }
    city { "MyString" }
    street { "MyString" }
    building { "MyString" }
    phone_number { "MyString" }
    order { nil }
  end
end
