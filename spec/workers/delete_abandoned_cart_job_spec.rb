# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteAbandonedCartJob, type: :job do
  subject(:job) { described_class.new }

  describe '#perform' do
    context 'when abandoned carts are old enough to be deleted' do
      let!(:old_cart) do
        create(:cart, status: :abandoned, last_interaction_at: 8.days.ago)
      end

      let!(:recent_cart) do
        create(:cart, status: :abandoned, last_interaction_at: 1.day.ago)
      end

      let!(:active_cart) do
        create(:cart, status: :active, last_interaction_at: 10.days.ago)
      end

      it 'deletes only old abandoned carts' do
        expect { job.perform }
          .to change(Cart, :count).by(-1)

        expect { old_cart.reload }
          .to raise_error(ActiveRecord::RecordNotFound)

        expect(recent_cart.reload).to be_persisted
        expect(active_cart.reload).to be_persisted
      end
    end

    context 'when no carts qualify' do
      let!(:cart) do
        create(:cart, status: :abandoned, last_interaction_at: 1.day.ago)
      end

      it 'does not delete anything' do
        expect { job.perform }
          .not_to change(Cart, :count)
      end
    end
  end
end
