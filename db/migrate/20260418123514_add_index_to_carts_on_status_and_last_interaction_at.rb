# frozen_string_literal: true

class AddIndexToCartsOnStatusAndLastInteractionAt < ActiveRecord::Migration[7.2]
  def change
    add_index :carts, %i[status last_interaction_at]
  end
end
