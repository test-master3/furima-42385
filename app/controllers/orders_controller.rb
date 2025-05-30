class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]

  def index
    @order = Order.new(item_id: params[:item_id])
  end

  def create
    @order = Order.new(order_params.merge(item_id: params[:item_id]))
    if @order.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def order_params
    params.require(:order).permit(:post_number, :prefecture_id, :city, :street, :building, :phone_number)
  end
end
