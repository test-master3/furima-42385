require 'rails_helper'

RSpec.describe OrderShippingAddress, type: :model do
  before do
    @order_shipping_address = FactoryBot.build(:order_shipping_address)
  end

  context '内容に問題ない場合' do
    it 'すべての情報があれば有効であること' do
      expect(@order_shipping_address).to be_valid
    end

    it '建物名がなくても購入できること' do
      @order_shipping_address.building = nil
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

    it 'phone_numberが半角数字以外が含まれている場合は購入できないこと' do
      @order_shipping_address.phone_number = '090-1234-5678'
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include('Phone number は携帯番号11桁で入力してください（例：09012345678）')
    end

    it 'phone_numberが9桁以下だと購入できないこと' do
      @order_shipping_address.phone_number = '090123456'
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include('Phone number は携帯番号11桁で入力してください（例：09012345678）')
    end

    it 'phone_numberが12桁以上だと購入できないこと' do
      @order_shipping_address.phone_number = '090123456789'
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include('Phone number は携帯番号11桁で入力してください（例：09012345678）')
    end

    it 'user_idが空では無効であること' do
      @order_shipping_address.user_id = nil
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include("User can't be blank")
    end

    it 'user_idが0以下では無効であること' do
      @order_shipping_address.user_id = 0
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include('User must be greater than 0')
    end

    it 'item_idが空では無効であること' do
      @order_shipping_address.item_id = nil
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include("Item can't be blank")
    end

    it 'item_idが0以下では無効であること' do
      @order_shipping_address.item_id = 0
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include('Item must be greater than 0')
    end

    it 'payjp_tokenが空では無効であること' do
      @order_shipping_address.payjp_token = nil
      @order_shipping_address.valid?
      expect(@order_shipping_address.errors.full_messages).to include('Payjp token クレジットカード情報を正しく入力してください')
    end
  end
end
