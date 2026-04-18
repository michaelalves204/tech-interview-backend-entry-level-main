# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartContracts::AddItemContract do
  subject(:contract) { described_class.new }

  describe 'params validation' do
    context 'when params are valid' do
      let(:input) do
        {
          product_id: 1,
          quantity: 2
        }
      end

      it 'is valid' do
        result = contract.call(input)

        expect(result.success?).to be true
      end
    end

    context 'when product_id is missing' do
      let(:input) do
        {
          quantity: 2
        }
      end

      it 'returns error for product_id' do
        result = contract.call(input)

        expect(result.success?).to be false
        expect(result.errors.to_h).to include(product_id: ['is missing'])
      end
    end

    context 'when quantity is missing' do
      let(:input) do
        {
          product_id: 1
        }
      end

      it 'returns error for quantity' do
        result = contract.call(input)

        expect(result.success?).to be false
        expect(result.errors.to_h).to include(quantity: ['is missing'])
      end
    end

    context 'when quantity is zero or negative' do
      let(:input) do
        {
          product_id: 1,
          quantity: 0
        }
      end

      it 'returns custom validation error' do
        result = contract.call(input)

        expect(result.success?).to be false
        expect(result.errors.to_h[:quantity]).to include('must be greater than 0')
      end
    end
  end
end
