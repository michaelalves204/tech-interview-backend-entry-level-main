# frozen_string_literal: true

class AddLastInteractionAtToCart < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :last_interaction_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }, null: false
  end
end
