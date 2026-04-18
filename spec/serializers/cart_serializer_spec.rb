# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartSerializer do
  subject(:serializer) { described_class.new(cart) }

  let(:cart) { create(:cart) }

  let!(:product1) { create(:product, name: 'Product A', price: 10) }
  let!(:product2) { create(:product, name: 'Product B', price: 5) }

  let!(:item1) do
    create(:cart_item, cart: cart, product: product1, quantity: 2, unit_price: 10)
  end

  let!(:item2) do
    create(:cart_item, cart: cart, product: product2, quantity: 3, unit_price: 5)
  end

  describe '#as_json' do
    it 'returns serialized cart structure' do
      result = serializer.as_json

      expect(result[:id]).to eq(cart.id)
      expect(result[:total_price]).to eq(cart.total_price.to_f)
    end

    it 'returns products with correct structure' do
      result = serializer.as_json

      expect(result[:products]).to match_array([
                                                 {
                                                   id: product1.id,
                                                   name: 'Product A',
                                                   quantity: 2,
                                                   unit_price: 10,
                                                   total_price: 20
                                                 },
                                                 {
                                                   id: product2.id,
                                                   name: 'Product B',
                                                   quantity: 3,
                                                   unit_price: 5,
                                                   total_price: 15
                                                 }
                                               ])
    end

    it 'calculates product total_price correctly' do
      result = serializer.as_json

      expect(result[:products].sum { |p| p[:total_price] }).to eq(35)
    end
  end
end
