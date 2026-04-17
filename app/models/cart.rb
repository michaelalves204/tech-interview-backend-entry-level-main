# frozen_string_literal: true

class Cart < ApplicationRecord
  enum :status, {
    active: 0,
    abandoned: 1
  }, suffix: true, default: :active, validate: true

  has_many :cart_items, dependent: :destroy
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  def recalculate_total!
    total = cart_items.sum { |item| item.quantity * item.unit_price }
    update!(total_price: total)
  end
end
