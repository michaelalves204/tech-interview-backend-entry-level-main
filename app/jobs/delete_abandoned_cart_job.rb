# frozen_string_literal: true

class DeleteAbandonedCartJob < ApplicationJob
  queue_as :low

  DELETE_AFTER_SECONDS = ENV.fetch('CART_DELETE_AFTER_SECONDS', 7.days.to_i).to_i

  def perform
    Cart.abandoned_status
        .where('last_interaction_at < ?', DELETE_AFTER_SECONDS.seconds.ago)
        .find_each(batch_size: 500, &:destroy)
  end
end
