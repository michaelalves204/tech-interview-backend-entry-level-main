# frozen_string_literal: true

module CartServices
  class CacheService
    def self.fetch_cart(cart_id)
      Rails.cache.fetch("cart_#{cart_id}", expires_in: 1.hour) do
        Cart.includes(cart_items: :product).find(cart_id)
      end
    end

    def self.invalidate_cart(cart_id)
      Rails.cache.delete("cart_#{cart_id}")
    end
  end
end
