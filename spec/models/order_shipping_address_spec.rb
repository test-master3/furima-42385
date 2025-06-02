require 'rails_helper'

RSpec.describe OrderShippingAddress, type: :model do
  before do
    @order_shipping_address = OrderShippingAddress.new(
      post_number: '123-4567',
      prefecture_id: 2,
      city: '東京都',
      street: '1-1-1',
      building: 'テストビル',
      phone_number: '09012345678',
      item_id: 1,
      user_id: 1,
      payjp_token: 'tok_test_token'
    )
  end

  context '内容に問題ない場合' do
    it 'すべての情報があれば有効であること' do
      expect(@order_shipping_address).to be_valid
    end
  end

  context '内容に問題がある場合' do
    it 'post_numberが空では無効であること' do
      @order_shipping_address.post_number = nil
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include("Post number can't be blank")
    end

    it 'post_numberが正しい形式でなければ無効であること' do
      @order_shipping_address.post_number = '1234567'
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include('Post number は正しい形式で入力してください（例：123-4567）')
    end

    it 'prefecture_idが1では無効であること' do
      @order_shipping_address.prefecture_id = 1
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include('Prefecture を選択してください')
    end

    it 'cityが空では無効であること' do
      @order_shipping_address.city = nil
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include("City can't be blank")
    end

    it 'streetが空では無効であること' do
      @order_shipping_address.street = nil
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include("Street can't be blank")
    end

    it 'phone_numberが空では無効であること' do
      @order_shipping_address.phone_number = nil
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include("Phone number can't be blank")
    end

    it 'phone_numberが正しい形式でなければ無効であること' do
      @order_shipping_address.phone_number = '1234567890'
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include('Phone number は携帯番号11桁で入力してください（例：09012345678）')
    end

    it 'payjp_tokenが空では無効であること' do
      @order_shipping_address.payjp_token = nil
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include("Payjp token can't be blank")
    end
  end
end
