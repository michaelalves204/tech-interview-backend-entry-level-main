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

  private

  def set_unit_price
    return unless product

    self.unit_price ||= product.price
  end
end
