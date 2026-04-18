# frozen_string_literal: true

class DeleteAbandonedCartJob
  include Sidekiq::Worker

  sidekiq_options queue: :low, retry: 3

  DELETE_AFTER_SECONDS = ENV.fetch('CART_DELETE_AFTER_SECONDS', 7.days.to_i).to_i

  def perform
    delete_abandoned_carts
  end

  private

  def delete_abandoned_carts
    delete_after_seconds = DELETE_AFTER_SECONDS.seconds.ago

    Cart.abandoned_status
        .abandoned_candidates(delete_after_seconds)
        .in_batches(of: 1000, &:destroy_all)
  end
end
