# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :move_to_root

  def show
    @items = current_user.items.where(status_id: 1)
  end
  
  def putting_up_list
    @items = current_user.items.where(status_id: 1)
  end

  def completed_item
    @items = current_user.items.where(status_id: 2)
  end

  def favorite_item
    @favorite_item_list = Favorite.where(user_id: current_user.id).includes(:item)
    @items = []
    @favorite_item_list.each do |favorite_item|
      @items << favorite_item.item
    end
  end

  def payment_method
    store_location
    @card = CreditCard.where(user_id: current_user.id).first
    if @card.blank?
      @card = CreditCard.new
    else
      Payjp.api_key = Rails.application.credentials[:payjp][:secret_key]
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @default_card_info = customer.cards.retrieve(@card.card_id)
    end
  end

  def logout
  end

  private

  def move_to_root
    redirect_to root_path unless user_signed_in?
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
