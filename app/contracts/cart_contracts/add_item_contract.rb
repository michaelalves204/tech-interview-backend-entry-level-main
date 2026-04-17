# frozen_string_literal: true

module CartContracts
  class AddItemContract < Dry::Validation::Contract
    params do
      required(:product_id).filled(:integer)
      required(:quantity).filled(:integer)
    end

    rule(:quantity) do
      key.failure('must be greater than 0') if value <= 0
    end
  end
end
