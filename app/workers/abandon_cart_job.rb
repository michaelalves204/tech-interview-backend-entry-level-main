# frozen_string_literal: true

class AbandonCartJob
  include Sidekiq::Worker

  sidekiq_options queue: :default

  ABANDON_AFTER_SECONDS = ENV.fetch('CART_ABANDON_AFTER_SECONDS', 3.hours.to_i).to_i

  def perform
    mark_as_abandoned
  end

  private

  def mark_as_abandoned
    abandon_after_seconds = ABANDON_AFTER_SECONDS.seconds.ago

    Cart.active_status
        .where('last_interaction_at < ?', abandon_after_seconds)
        .in_batches(of: 1000) do |batch|
          batch.update_all(
            status: Cart.statuses[:abandoned],
            updated_at: Time.current
          )
        end
  end
end
