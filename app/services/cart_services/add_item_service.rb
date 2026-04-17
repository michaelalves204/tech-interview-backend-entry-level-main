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

      cart_item = CartItem.find_or_initialize_by(cart: @cart, product: @product)

      cart_item.quantity = cart_item.quantity.to_i + quantity
      cart_item.unit_price ||= @product.price
      cart_item.save!

      { success: true }
    end
  end
end
