# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AbandonCartJob, type: :job do
  include ActiveSupport::Testing::TimeHelpers

  subject(:job) { described_class.new }

  let(:now) { Time.current }

  before { travel_to(now) }

  describe '#perform' do
    context 'when carts are old enough to be abandoned' do
      let!(:old_cart) do
        create(:cart, status: :active, last_interaction_at: 4.hours.ago)
      end

      let!(:recent_cart) do
        create(:cart, status: :active, last_interaction_at: 1.hour.ago)
      end

      it 'marks only old carts as abandoned' do
        job.perform

        expect(old_cart.reload).to be_abandoned_status
        expect(recent_cart.reload).to be_active_status
      end
    end

    context 'when no carts qualify' do
      let!(:cart) do
        create(:cart, status: :active, last_interaction_at: 1.hour.ago)
      end

      it 'does not change cart status' do
        job.perform

        expect(cart.reload).to be_active_status
      end
    end
  end
end
