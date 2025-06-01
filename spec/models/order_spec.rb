require 'rails_helper'

RSpec.describe Order, type: :model do
  before do
    @order = FactoryBot.build(:order)
  end

  describe '商品購入' do
    context '商品購入ができる場合' do
      it 'すべての情報が正しく入力されていれば購入できる' do
        expect(@order).to be_valid
      end
    end
  end
end
