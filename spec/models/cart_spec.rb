# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  subject(:cart) { build(:cart, total_price: total_price) }

  describe 'validations' do
    context 'when total_price is negative' do
      let(:total_price) { -10 }

      it { is_expected.not_to be_valid }
    end

    context 'when total_price is zero' do
      let(:total_price) { 0 }

      it { is_expected.to be_valid }
    end

    context 'when total_price is positive' do
      let(:total_price) { 10 }

      it { is_expected.to be_valid }
    end
  end

  describe 'status enum' do
    subject(:cart) { create(:cart) }

    it 'defaults to active' do
      expect(cart).to be_active_status
    end

    it 'can be marked as abandoned' do
      cart.abandoned_status!

      expect(cart).to be_abandoned_status
    end
  end

  describe '.abandoned_candidates' do
    let(:threshold) { 3.hours.ago }

    context 'when cart is older than threshold' do
      let!(:old_cart) do
        create(:cart, status: :active, last_interaction_at: 4.hours.ago)
      end

      it 'includes the cart in results' do
        expect(described_class.abandoned_candidates(threshold)).to include(old_cart)
      end
    end

    context 'when cart is newer than threshold' do
      let!(:recent_cart) do
        create(:cart, status: :active, last_interaction_at: 1.hour.ago)
      end

      it 'does not include the cart in results' do
        expect(described_class.abandoned_candidates(threshold)).not_to include(recent_cart)
      end
    end

    context 'when abandoned cart is older than threshold' do
      let!(:abandoned_cart) do
        create(:cart, status: :abandoned, last_interaction_at: 10.hours.ago)
      end

      it 'still includes the cart (scope ignores status)' do
        expect(described_class.abandoned_candidates(threshold)).to include(abandoned_cart)
      end
    end

    context 'when cart is exactly at threshold' do
      let!(:edge_cart) do
        create(:cart, status: :active, last_interaction_at: threshold)
      end

      it 'does not include the cart' do
        expect(described_class.abandoned_candidates(threshold)).not_to include(edge_cart)
      end
    end
  end

  describe '#refresh_after_interaction!' do
    include ActiveSupport::Testing::TimeHelpers

    subject(:cart) { create(:cart, status: initial_status, last_interaction_at: 2.hours.ago, total_price: 0) }

    let(:initial_status) { :abandoned }

    let!(:first_item) do
      create(:cart_item, cart: cart, quantity: 2, unit_price: 10)
    end

    let!(:second_item) do
      create(:cart_item, cart: cart, quantity: 1, unit_price: 5)
    end

    it 'recalculates total_price correctly' do
      cart.refresh_after_interaction!

      expect(cart.reload.total_price).to eq(25)
    end

    it 'updates last_interaction_at to current time' do
      freeze_time do
        cart.refresh_after_interaction!

        expect(cart.reload.last_interaction_at).to eq(Time.current)
      end
    end

    it 'sets status to active' do
      cart.refresh_after_interaction!

      expect(cart.reload).to be_active_status
    end
  end

  describe 'cache invalidation' do
    let(:cart) { create(:cart) }

    it 'invalidates cache after commit' do
      expect(CartServices::CacheService)
        .to receive(:invalidate_cart)
        .with(cart.id)

      cart.update!(total_price: 100)
    end
  end
end
