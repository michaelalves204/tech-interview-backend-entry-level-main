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
    Cart.abandoned_status.abandoned_candidates(DELETE_AFTER_SECONDS.seconds.ago)
        .find_each(batch_size: 500, &:destroy)
  end
end
