class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]
  before_action :move_to_index, only: [:index, :create]

  def index
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    @order_shipping_address = OrderShippingAddress.new
  end

  def create
    @order_shipping_address = OrderShippingAddress.new(order_params)

    if @order_shipping_address.valid?
      begin
        Payjp.api_key = ENV['PAYJP_SECRET_KEY']
        Payjp::Charge.create(
          amount: @item.price,
          card: params[:payjp_token],
          currency: 'jpy'
        )
        @order_shipping_address.save
        redirect_to root_path
      rescue Payjp::PayjpError => e
        @order_shipping_address.errors.add(:base, "決済に失敗しました: #{e.message}")
        gon.public_key = ENV['PAYJP_PUBLIC_KEY']
        render :index, status: :unprocessable_entity
      rescue StandardError
        @order_shipping_address.errors.add(:base, '予期しないエラーが発生しました')
        gon.public_key = ENV['PAYJP_PUBLIC_KEY']
        render :index, status: :unprocessable_entity
      end
    else
      gon.public_key = ENV['PAYJP_PUBLIC_KEY']
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
