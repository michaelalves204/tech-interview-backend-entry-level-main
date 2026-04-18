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
      return failure(contract.errors.to_h) if contract.failure?

      update_cart_item!
      update_cart_total!

      success
    end

    private

    attr_reader :cart, :product, :params

    def contract
      @contract ||= CartContracts::AddItemContract.new.call(params)
    end

    def quantity
      contract[:quantity]
    end

    def cart_item
      @cart_item ||= CartItem.find_or_initialize_by(cart: cart, product: product)
    end

    def update_cart_item!
      cart_item.quantity = new_quantity
      cart_item.unit_price ||= product.price
      cart_item.save!
    end

    def new_quantity
      return quantity if cart_item.new_record?

      cart_item.quantity + quantity
    end

    def update_cart_total!
      total = cart.cart_items.sum('quantity * unit_price')
      cart.update!(total_price: total)
    end

    def success
      { success: true }
    end

    def failure(errors)
      { success: false, errors: errors }
    end
  end
end
