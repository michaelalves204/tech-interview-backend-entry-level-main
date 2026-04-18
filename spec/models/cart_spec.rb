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
end
