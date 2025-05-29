class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  # before_action :set_item, only: [:show]  # 詳細表示機能実装時に使用

  def index
    @items = Item.order(created_at: :desc)
    #   @items = Item.includes(:user).order(created_at: :desc)
    # end

    # def show  # 詳細表示機能実装時に使用
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params.merge(user_id: current_user.id))

    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # def set_item  # 詳細表示機能実装時に使用
  #   @item = Item.find(params[:id])
  # end

  def item_params
    params.require(:item).permit(:name, :description, :price, :category_id, :state_id, :delivery_cost_id, :delivery_date_id,
                                 :prefecture_id, :image)
  end
end
