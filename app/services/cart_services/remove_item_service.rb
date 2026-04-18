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
      return failure('Product not in cart') unless cart_item

      remove_item!
      update_cart_total!

      success
    end

    private

    attr_reader :cart, :product_id

    def cart_item
      @cart_item ||= cart.cart_items.find_by(product_id: product_id)
    end

    def remove_item!
      cart_item.destroy!
    end

    def update_cart_total!
      total = cart.cart_items.sum('quantity * unit_price')
      cart.update!(total_price: total)
    end

    def success
      { success: true }
    end

    def failure(error)
      { success: false, error: error }
    end
  end
end
