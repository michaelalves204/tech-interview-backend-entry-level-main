# frozen_string_literal: true

class Cart < ApplicationRecord
  enum :status, {
    active: 0,
    abandoned: 1
  }, suffix: true, default: :active, validate: true

  has_many :cart_items, dependent: :destroy
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  scope :abandoned_candidates, lambda { |threshold|
    where('last_interaction_at < ?', threshold)
  }

  after_commit :invalidate_cache

  def refresh_after_interaction!
    update!(
      total_price: cart_items.sum('quantity * unit_price'),
      last_interaction_at: Time.current,
      status: :active
    )
  end

  def invalidate_cache
    CartServices::CacheService.invalidate_cart(id)
  end
end
