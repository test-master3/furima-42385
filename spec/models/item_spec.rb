require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:item) { FactoryBot.build(:item, user: user) }

  describe 'バリデーション' do
    context '正常系' do
      it '全ての項目が正しく入力されていれば保存できる' do
        expect(item).to be_valid
      end
    end

    context '異常系 - presence バリデーション' do
      it '商品名が空の場合はバリデーションエラー' do
        item.name = ''
        expect(item).not_to be_valid
        expect(item.errors[:name]).to include("can't be blank")
      end

      it '商品の説明が空の場合はバリデーションエラー' do
        item.description = ''
        expect(item).not_to be_valid
        expect(item.errors[:description]).to include("can't be blank")
      end

      it '価格が空の場合はバリデーションエラー' do
        item.price = nil
        expect(item).not_to be_valid
        expect(item.errors[:price]).to include("can't be blank")
      end

      it 'カテゴリーが空の場合はバリデーションエラー' do
        item.category_id = nil
        expect(item).not_to be_valid
        expect(item.errors[:category_id]).to include("can't be blank")
      end

      it '商品の状態が空の場合はバリデーションエラー' do
        item.state_id = nil
        expect(item).not_to be_valid
        expect(item.errors[:state_id]).to include("can't be blank")
      end

      it '配送料の負担が空の場合はバリデーションエラー' do
        item.delivery_cost_id = nil
        expect(item).not_to be_valid
        expect(item.errors[:delivery_cost_id]).to include("can't be blank")
      end

      it '発送元の地域が空の場合はバリデーションエラー' do
        item.prefecture_id = nil
        expect(item).not_to be_valid
        expect(item.errors[:prefecture_id]).to include("can't be blank")
      end

      it '発送までの日数が空の場合はバリデーションエラー' do
        item.delivery_date_id = nil
        expect(item).not_to be_valid
        expect(item.errors[:delivery_date_id]).to include("can't be blank")
      end
    end

    context '異常系 - 選択肢バリデーション' do
      it 'カテゴリーが未選択（1）の場合はバリデーションエラー' do
        item.category_id = 1
        expect(item).not_to be_valid
        expect(item.errors[:category_id]).to include('を選択してください')
      end

      it '商品の状態が未選択（1）の場合はバリデーションエラー' do
        item.state_id = 1
        expect(item).not_to be_valid
        expect(item.errors[:state_id]).to include('を選択してください')
      end

      it '配送料の負担が未選択（1）の場合はバリデーションエラー' do
        item.delivery_cost_id = 1
        expect(item).not_to be_valid
        expect(item.errors[:delivery_cost_id]).to include('を選択してください')
      end

      it '発送元の地域が未選択（1）の場合はバリデーションエラー' do
        item.prefecture_id = 1
        expect(item).not_to be_valid
        expect(item.errors[:prefecture_id]).to include('を選択してください')
      end

      it '発送までの日数が未選択（1）の場合はバリデーションエラー' do
        item.delivery_date_id = 1
        expect(item).not_to be_valid
        expect(item.errors[:delivery_date_id]).to include('を選択してください')
      end
    end

    context '異常系 - 価格バリデーション' do
      it '価格が299円以下の場合はバリデーションエラー' do
        item.price = 299
        expect(item).not_to be_valid
        expect(item.errors[:price]).to include('は300円以上9,999,999円以下で入力してください')
      end

      it '価格が10,000,000円以上の場合はバリデーションエラー' do
        item.price = 10_000_000
        expect(item).not_to be_valid
        expect(item.errors[:price]).to include('は300円以上9,999,999円以下で入力してください')
      end

      it '価格が整数でない場合はバリデーションエラー' do
        item.price = 1000.5
        expect(item).not_to be_valid
        expect(item.errors[:price]).to include('は300円以上9,999,999円以下で入力してください')
      end

      it '価格が文字列の場合はバリデーションエラー' do
        item.price = 'abc'
        expect(item).not_to be_valid
        expect(item.errors[:price]).to include('は300円以上9,999,999円以下で入力してください')
      end
    end

    context '正常系 - 価格の境界値' do
      it '価格が300円の場合は保存できる' do
        item.price = 300
        expect(item).to be_valid
      end

      it '価格が9,999,999円の場合は保存できる' do
        item.price = 9_999_999
        expect(item).to be_valid
      end
    end

    context 'アソシエーション' do
      it 'ユーザーが関連付けられていない場合はバリデーションエラー' do
        item.user = nil
        expect(item).not_to be_valid
      end
    end
  end
end
