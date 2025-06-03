class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :move_to_index, only: [:edit, :update, :destroy]

  def index
    @items = Item.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.build(item_params)

    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_index
    # 所有者以外のアクセスをブロック
    if user_signed_in? && current_user.id != @item.user_id
      redirect_to root_path
      return
    end

    # 売り切れ商品の編集をブロック
    return unless @item.order.present?

    redirect_to root_path
    nil
  end

  def item_params
    params.require(:item).permit(:name, :description, :price, :category_id, :state_id, :delivery_cost_id, :delivery_date_id,
                                 :prefecture_id, :image)
  end
end
