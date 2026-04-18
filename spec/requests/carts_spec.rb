# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/carts', type: :request do
  let(:product) { create(:product) }

  describe 'POST /cart' do
    it 'creates cart item and returns cart payload' do
      post '/cart', params: { product_id: product.id, quantity: 2 }

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)

      expect(json).to include(
        'products' => [
          include(
            'id' => product.id,
            'quantity' => 2
          )
        ]
      )
    end
  end

  describe 'POST /cart/add_item' do
    before do
      post '/cart', params: { product_id: product.id, quantity: 1 }
    end

    it 'returns updated cart payload' do
      post '/cart/add_item', params: { product_id: product.id, quantity: 1 }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to include(
        'products' => [
          include(
            'id' => product.id,
            'quantity' => 2
          )
        ]
      )
    end
  end

  describe 'GET /cart' do
    before do
      post '/cart', params: { product_id: product.id, quantity: 1 }
    end

    it 'returns cart payload' do
      get '/cart'

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to include(
        'products' => [
          include(
            'id' => product.id,
            'quantity' => 1
          )
        ]
      )
    end
  end

  describe 'DELETE /cart/:product_id' do
    before do
      post '/cart', params: { product_id: product.id, quantity: 1 }
    end

    it 'returns empty cart payload after removal' do
      delete "/cart/#{product.id}"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json).to include(
        'products' => []
      )
    end

    it 'returns not found when product does not exist' do
      delete '/cart/999999'

      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)

      expect(json).to include(
        'error' => be_present
      )
    end
  end
end
