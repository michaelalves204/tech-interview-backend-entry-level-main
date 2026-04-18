# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartServices::RemoveItemService do
  subject(:service_call) do
    described_class.call(cart: cart, product_id: product_id)
  end

  let(:cart) { create(:cart) }

  describe '.call' do
    context 'when product exists in cart' do
      let(:product) { create(:product) }
      let!(:cart_item) do
        create(:cart_item, cart: cart, product: product, quantity: 2, unit_price: 10)
      end

      let(:product_id) { product.id }

      it 'removes item from cart' do
        expect { service_call }.to change(CartItem, :count).by(-1)
      end

      it 'returns success true' do
        result = service_call

        expect(result[:success]).to be true
      end

      it 'actually deletes the correct item' do
        service_call

        expect { cart_item.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when product does not exist in cart' do
      let(:product_id) { 999_999 }

      it 'does not change cart_items' do
        expect { service_call }.not_to change(CartItem, :count)
      end

      it 'returns error response' do
        result = service_call

        expect(result[:success]).to be false
        expect(result[:error]).to eq('Product not in cart')
      end
    end
  end
end
