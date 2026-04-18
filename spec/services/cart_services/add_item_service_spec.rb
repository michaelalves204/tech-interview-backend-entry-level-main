# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartServices::AddItemService do
  subject(:service_call) do
    described_class.call(cart: cart, product: product, params: params)
  end

  let(:cart) { create(:cart) }
  let(:product) { create(:product, price: 10) }

  describe '.call' do
    context 'when params are valid' do
      let(:params) do
        {
          product_id: product.id,
          quantity: 2
        }
      end

      it 'adds item to cart successfully' do
        result = service_call

        expect(result[:success]).to be true
      end

      it 'creates a new cart_item with correct quantity and price' do
        expect { service_call }.to change(CartItem, :count).by(1)

        item = CartItem.last

        expect(item.cart).to eq(cart)
        expect(item.product).to eq(product)
        expect(item.quantity).to eq(2)
        expect(item.unit_price.to_f).to eq(product.price.to_f)
      end
    end

    context 'when item already exists in cart' do
      let!(:existing_item) do
        create(:cart_item, cart: cart, product: product, quantity: 1, unit_price: 10)
      end

      let(:params) do
        {
          product_id: product.id,
          quantity: 3
        }
      end

      it 'increments quantity instead of creating new item' do
        expect { service_call }.not_to change(CartItem, :count)

        expect(existing_item.reload.quantity).to eq(4)
      end
    end

    context 'when params are invalid' do
      let(:params) do
        {
          product_id: product.id,
          quantity: 0
        }
      end

      it 'returns failure with errors' do
        result = service_call

        expect(result[:success]).to be false
        expect(result[:errors]).to be_present
      end

      it 'does not create cart_item' do
        expect { service_call }.not_to change(CartItem, :count)
      end
    end
  end
end
