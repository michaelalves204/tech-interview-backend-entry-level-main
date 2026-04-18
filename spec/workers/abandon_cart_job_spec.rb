# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AbandonCartJob, type: :job do
  include ActiveSupport::Testing::TimeHelpers

  around do |example|
    freeze_time { example.run }
  end

  describe '#perform' do
    context 'when carts last interaction exceeds abandonment threshold' do
      let!(:old_cart) do
        create(:cart, status: :active, last_interaction_at: 4.hours.ago)
      end

      let!(:recent_cart) do
        create(:cart, status: :active, last_interaction_at: 1.hour.ago)
      end

      it 'marks only old carts as abandoned' do
        expect { described_class.new.perform }
          .to change { old_cart.reload.status }
          .from('active').to('abandoned')

        expect(recent_cart.reload.status).to eq('active')
      end
    end

    context 'when cart is exactly at the threshold' do
      let!(:edge_cart) do
        create(:cart, status: :active, last_interaction_at: 3.hours.ago)
      end

      it 'does not abandon the cart' do
        described_class.new.perform

        expect(edge_cart.reload.status).to eq('active')
      end
    end

    context 'when no carts qualify' do
      let!(:cart) do
        create(:cart, status: :active, last_interaction_at: 1.hour.ago)
      end

      it 'does not change cart status' do
        expect { described_class.new.perform }
          .not_to(change { cart.reload.status })
      end
    end

    context 'when job runs multiple times' do
      let!(:old_cart) do
        create(:cart, status: :active, last_interaction_at: 4.hours.ago)
      end

      it 'is idempotent' do
        described_class.new.perform

        expect { described_class.new.perform }
          .not_to(change { old_cart.reload.status })
      end
    end
  end
end
