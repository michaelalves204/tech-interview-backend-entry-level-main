# frozen_string_literal: true

module CartServices
  class AddItemService
    def self.call(cart:, product:, params:)
      new(cart, product, params).call
    end

    def initialize(cart, product, params)
      @cart = cart
      @product = product
      @params = params
    end

    def call
      contract = CartContracts::AddItemContract.new.call(@params)

      return { success: false, errors: contract.errors.to_h } if contract.failure?

      quantity = contract[:quantity]

      cart_item = CartItem.find_or_initialize_by(
        cart: @cart,
        product: @product
      )

      if cart_item.new_record?
        cart_item.quantity = quantity
      else
        cart_item.quantity += quantity
      end

      cart_item.unit_price ||= @product.price
      cart_item.save!

      update_cart_total!

      { success: true }
    end

    private

    def update_cart_total!
      total = @cart.cart_items.sum('quantity * unit_price')
      @cart.update!(total_price: total)
    end
  end
end
