class OrderShippingAddress
  include ActiveModel::Model
  attr_accessor :post_number, :prefecture_id, :city, :street, :building, :phone_number, :item_id, :user_id, :payjp_token

  with_options presence: true do
    validates :post_number, format: { with: /\A\d{3}-\d{4}\z/, message: 'は正しい形式で入力してください（例：123-4567）' }
    validates :city
    validates :street
    validates :phone_number, format: { with: /\A(090|080|070)\d{8}\z/, message: 'は携帯番号11桁で入力してください（例：09012345678）' }
    validates :user_id, numericality: { only_integer: true, greater_than: 0 }
    validates :item_id, numericality: { only_integer: true, greater_than: 0 }
  end

  validates :prefecture_id, numericality: { other_than: 1, message: 'を選択してください' }
  validates :payjp_token, presence: { message: 'クレジットカード情報を正しく入力してください' }

  def save
    return false unless valid?

    order = Order.create(item_id: item_id, user_id: user_id)
    ShippingAddress.create(post_number: post_number, prefecture_id: prefecture_id, city: city, street: street,
                           building: building, phone_number: phone_number, order_id: order.id)
  end
end
