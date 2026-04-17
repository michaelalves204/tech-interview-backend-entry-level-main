# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :product, presence: true
  validates :cart, presence: true
  validates :quantity, presence: true,
                       numericality: { only_integer: true, greater_than: 0 }

  validates :unit_price, presence: true,
                         numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_unit_price

  after_save :update_cart_total
  after_destroy :update_cart_total

  private

  def update_cart_total
    cart.recalculate_total!
  end

  def set_unit_price
    return unless product

    self.unit_price ||= product.price
  end
end
