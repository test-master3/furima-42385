class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @items = Item.includes(:user).order(created_at: :desc)
  end

  def show
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'アイテムが見つかりません'
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
    @item = current_user.items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'アクセス権限がありません'
  end

  def update
    @item = current_user.items.find(params[:id])

    if @item.update(item_params)
      redirect_to item_path(@item.id)
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'アクセス権限がありません'
  end

  def destroy
    @item = current_user.items.find(params[:id])
    @item.destroy
    redirect_to root_path
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'アクセス権限がありません'
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :category_id, :state_id, :delivery_cost_id, :delivery_date_id,
                                 :prefecture_id, :image)
  end
end
