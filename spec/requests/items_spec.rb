require 'rails_helper'

RSpec.describe 'Items', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:valid_attributes) do
    {
      name: 'テスト商品',
      description: 'テスト商品の説明',
      category_id: 2,
      state_id: 2,
      delivery_cost_id: 2,
      prefecture_id: 2,
      delivery_date_id: 2,
      price: 1000
    }
  end

  describe 'GET /items' do
    it '商品一覧ページが正常に表示される' do
      get items_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /items/new' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '商品出品ページが正常に表示される' do
        get new_item_path
        expect(response).to have_http_status(200)
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされる' do
        get new_item_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /items' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      context '有効なパラメータの場合' do
        it '商品が作成される' do
          expect do
            post items_path, params: { item: valid_attributes }
          end.to change(Item, :count).by(1)
        end

        it '商品一覧ページにリダイレクトされる' do
          post items_path, params: { item: valid_attributes }
          expect(response).to redirect_to(items_path)
        end
      end

      context '無効なパラメータの場合' do
        it '商品が作成されない' do
          expect do
            post items_path, params: { item: { name: '' } }
          end.not_to change(Item, :count)
        end

        it 'newテンプレートが再表示される' do
          post items_path, params: { item: { name: '' } }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされる' do
        post items_path, params: { item: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
