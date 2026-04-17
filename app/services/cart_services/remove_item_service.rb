# frozen_string_literal: true

module CartServices
  class RemoveItemService
    def self.call(cart:, product_id:)
      new(cart, product_id).call
    end

    def initialize(cart, product_id)
      @cart = cart
      @product_id = product_id
    end

    def call
      cart_item = @cart.cart_items.find_by(product_id: @product_id)

      return { success: false, error: 'Product not in cart' } unless cart_item

      cart_item.destroy

      { success: true }
    end
  end
end
