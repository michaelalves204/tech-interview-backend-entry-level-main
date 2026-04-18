# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:cart) { create(:cart) }
  let(:product) { create(:product, price: 10) }

  subject(:cart_item) do
    build(:cart_item, cart: cart, product: product, quantity: quantity, unit_price: unit_price)
  end

  describe 'validations' do
    context 'quantity' do
      let(:unit_price) { 10 }

      context 'when invalid' do
        let(:quantity) { 0 }

        it { is_expected.not_to be_valid }
      end

      context 'when valid' do
        let(:quantity) { 2 }

        it { is_expected.to be_valid }
      end
    end

    context 'unit_price' do
      let(:quantity) { 1 }

      context 'when negative' do
        let(:unit_price) { -1 }

        it { is_expected.not_to be_valid }
      end

      context 'when valid' do
        let(:unit_price) { 10 }

        it { is_expected.to be_valid }
      end
    end

    context 'associations' do
      let(:quantity) { 1 }
      let(:unit_price) { 10 }

      it 'requires cart' do
        cart_item.cart = nil
        expect(cart_item).not_to be_valid
      end

      it 'requires product' do
        cart_item.product = nil
        expect(cart_item).not_to be_valid
      end
    end
  end

  describe 'callbacks' do
    let(:quantity) { 2 }
    let(:unit_price) { 10 }

    it 'sets unit_price from product when not provided' do
      item = build(:cart_item, cart: cart, product: product, unit_price: nil)

      item.valid?

      expect(item.unit_price).to eq(product.price)
    end

    it 'does not override unit_price if already set' do
      item = build(:cart_item, cart: cart, product: product, unit_price: 20)

      item.valid?

      expect(item.unit_price).to eq(20)
    end

    it 'updates cart total after destroy' do
      item = create(:cart_item, cart: cart, product: product, quantity: 2, unit_price: 10)

      item.reload

      item.destroy

      expect(cart.reload.total_price.to_f).to eq(0.0)
    end
  end
end
