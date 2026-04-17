# frozen_string_literal: true

class AbandonCartJob < ApplicationJob
  queue_as :default

  ABANDON_AFTER_SECONDS = ENV.fetch('CART_ABANDON_AFTER_SECONDS', 3.hours.to_i).to_i

  def perform
    mark_as_abandoned
  end

  private

  def mark_as_abandoned
    Cart.active_status
        .where('last_interaction_at < ?', ABANDON_AFTER_SECONDS.seconds.ago)
        .update_all(
          status: Cart.statuses[:abandoned],
          updated_at: Time.current
        )
  end
end
