# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartServices::CacheService do
  describe '.fetch_cart' do
    let!(:cart) do
      create(:cart).tap do |c|
        create(:cart_item, cart: c, quantity: 2, unit_price: 10)
      end
    end

    context 'when cache is empty' do
      it 'loads cart from database and stores in cache' do
        expect(Rails.cache).to receive(:fetch).and_call_original

        result = described_class.fetch_cart(cart.id)

        expect(result).to eq(cart)
      end
    end

    context 'when cache is already populated' do
      it 'does not hit database again' do
        described_class.fetch_cart(cart.id)

        expect(Cart).not_to receive(:find)

        described_class.fetch_cart(cart.id)
      end
    end
  end

  describe '.invalidate_cart' do
    let!(:cart) { create(:cart) }

    it 'removes cached cart' do
      described_class.fetch_cart(cart.id)

      described_class.invalidate_cart(cart.id)

      expect(described_class.fetch_cart(cart.id)).not_to be_nil
    end
  end
end
