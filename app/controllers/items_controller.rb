class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user = current_user # 現在のユーザーを関連付け

    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :category_id, :state_id, :delivery_cost_id, :delivery_date_id,
                                 :prefecture_id, :image)
  end
end
