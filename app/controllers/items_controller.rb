class ItemsController < ApplicationController
  before_action :move_to_root, only: [:new, :edit]
  before_action :correct_user, only: [:destroy, :edit, :update]
  before_action :set_item, only: [:edit, :update, :show, :destroy, :buy, :pay, :favorite]
  before_action :set_category, only: [:edit, :update]

  def top
    @new_items = Item.where(status_id: 1).order(created_at: :desc).limit(5)
  end

  def index
  end

  def new
    @item = Item.new
    @item.item_images.new
    @categories = Category.where(ancestry: nil)
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: "商品を出品しました"
    else
      if @item.category != nil
        set_category
        if @item.size !=nil
          @sizes = @item.size.siblings
        end
      end
      @item.item_images.new
      @categories = Category.where(ancestry: nil)
      render :new
    end
  end
  
  def show
    category = Category.find(@item.category_id)
    # 「もっと見る」表示用のインスタンス
    @more_items = category.items.where(status_id: 1).where.not(id: @item.id).order(created_at: :desc).limit(5)
    # 「前の商品」「後ろの商品」表示用のインスタンス
    @items = category.items.where(status_id: 1)
    @favorite_number = Favorite.where(item_id: @item.id).length
    # current_userのいいねが存在するかどうか
    if user_signed_in?
      @exist_favorite = Favorite.find_by(item_id: @item.id, user_id: current_user.id).blank?
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def buy
    store_location
    if user_signed_in?
      @user = current_user.destination
      @card = CreditCard.where(user_id: current_user.id).first
      unless @card.blank?
        Payjp.api_key = Rails.application.credentials[:payjp][:secret_key]
        customer = Payjp::Customer.retrieve(@card.customer_id)
        @default_card_info = customer.cards.retrieve(@card.card_id)
      end
      @pref = JpPrefecture::Prefecture.find(@user.prefecture_code)
    else
      redirect_to new_user_session_path
    end
  end

  # 登録したカードで支払い
  def pay
    card = CreditCard.where(user_id: current_user.id).first
    if card.blank?
      redirect_to new_credit_card_path
    else
      Payjp.api_key = Rails.application.credentials[:payjp][:secret_key]
      Payjp::Charge.create(
        amount: @item.price,
        customer: card.customer_id, 
        currency: 'jpy'
      )
      @item.update(status_id: '2')
      redirect_to thanks_items_path
    end
  end

  def thanks
  end
  
  def edit
    if @item.size !=nil
      @sizes = @item.size.siblings
    end
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(params[:id]), notice: "商品情報を変更しました"
    else
      if @item.size !=nil
        @sizes = @item.size.siblings
      end
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to root_path, notice: "出品を取り消しました"
    else
      redirect_to root_path, alert: "エラーが発生しました"
    end
  end

  def favorite
    exist_favorite = Favorite.find_by(item_id: @item.id, user_id: current_user.id)
    if exist_favorite == nil
      Favorite.create(item_id: @item.id, user_id: current_user.id)
    else
      exist_favorite.destroy
    end
    @favorite_number = Favorite.where(item_id: @item.id).length
  end

  private
  def item_params
    params.require(:item).permit(:name, :introduction, :price, :category_id, :size_id, :brand_id,:item_condition_id, :postage_payer_id, :prefecture_code, :preparation_day_id, :status_id, item_images_attributes: [:url, :_destroy, :id]).merge(user_id: current_user.id)
  end

  def move_to_root
    redirect_to action: :top unless user_signed_in?
  end

  def correct_user
    seler_user = Item.find(params[:id]).user
    redirect_to(root_path) unless seler_user == current_user
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_category
    @category = @item.category
    # 登録カテゴリーが子の場合か孫の場合で分岐
    if @category.ancestors.length == 1 
      @categories_child = @category.siblings
      @categories_parent = @category.parent.siblings
    else 
      @categories_parent = @category.parent.parent.siblings
      @categories_child = @category.parent.siblings
      @categories_grandchild = @category.siblings
    end
  end

  def order_params
    params.permit(:token)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
