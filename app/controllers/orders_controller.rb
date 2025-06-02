class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]
  before_action :move_to_index, only: [:index, :create]

  def index
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    @order_shipping_address = OrderShippingAddress.new
  end

  def create
    # デバッグ用ログ
    Rails.logger.info '=== 決済処理開始 ==='
    Rails.logger.info "PAY.JPトークン: #{params[:payjp_token]}"
    Rails.logger.info "商品価格: #{@item.price}"

    @order_shipping_address = OrderShippingAddress.new(order_params)

    if @order_shipping_address.valid?
      begin
        Payjp.api_key = ENV['PAYJP_SECRET_KEY']
        charge = Payjp::Charge.create(
          amount: @item.price,
          card: params[:payjp_token],
          currency: 'jpy'
        )
        Rails.logger.info "決済成功: #{charge.id}"
        @order_shipping_address.save
        redirect_to root_path
      rescue Payjp::PayjpError => e
        Rails.logger.error "PAY.JPエラー: #{e.message}"
        @order_shipping_address.errors.add(:base, "決済に失敗しました: #{e.message}")
        render :index, status: :unprocessable_entity
      rescue StandardError => e
        Rails.logger.error "その他のエラー: #{e.message}"
        @order_shipping_address.errors.add(:base, '予期しないエラーが発生しました')
        render :index, status: :unprocessable_entity
      end
    else
      Rails.logger.error "バリデーションエラー: #{@order_shipping_address.errors.full_messages}"
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def move_to_index
    redirect_to root_path if current_user.id == @item.user_id || @item.order.present?
  end

  def order_params
    params.require(:order_shipping_address).permit(:post_number, :prefecture_id, :city, :street, :building, :phone_number).merge(
      item_id: params[:item_id], user_id: current_user.id, payjp_token: params[:payjp_token]
    )
  end
end
