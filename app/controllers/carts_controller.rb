# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :set_cart
  before_action :set_product, only: %i[create add_item]

  def create
    handle_add_item(:created)
  end

  def add_item
    handle_add_item(:ok)
  end

  def remove_item
    result = ::CartServices::RemoveItemService.call(
      cart: @cart,
      product_id: params[:product_id]
    )

    return render json: { error: result[:error] }, status: :not_found unless result[:success]

    render json: CartSerializer.new(@cart).as_json, status: :ok
  end

  def show
    return render json: { error: I18n.t('errors.cart.not_found') }, status: :not_found unless @cart

    render json: CartSerializer.new(@cart).as_json, status: :ok
  end

  private

  def handle_add_item(status)
    result = ::CartServices::AddItemService.call(
      cart: @cart,
      product: @product,
      params: params.to_unsafe_h
    )

    return render json: { errors: result[:errors] }, status: :unprocessable_entity unless result[:success]

    render json: CartSerializer.new(@cart).as_json, status: status
  end

  def set_product
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('errors.product.not_found') }, status: :not_found
  end

  def set_cart
    @cart = Cart.find_by(id: session[:cart_id])

    return if @cart

    @cart = Cart.create!(total_price: 0)
    session[:cart_id] = @cart.id
  end
end
