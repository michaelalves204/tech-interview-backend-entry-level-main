# frozen_string_literal: true

class CartSerializer
  def initialize(cart)
    @cart = CartServices::CacheService.fetch_cart(cart.id)
  end

  def as_json(*)
    {
      id: @cart.id,
      products: products,
      total_price: @cart.total_price.to_f
    }
  end

  private

  def cart_items
    @cart.cart_items
  end

  def products
    cart_items.map do |item|
      {
        id: item.product.id,
        name: item.product.name,
        quantity: item.quantity,
        unit_price: item.unit_price,
        total_price: item.quantity * item.unit_price
      }
    end
  end
end
