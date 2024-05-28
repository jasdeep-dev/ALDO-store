# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventoryUpdateService, type: :service do
  let(:store) { create(:store, name: 'Test Store') }
  let(:shoe_model) { create(:shoe_model, name: 'Test Model') }
  let!(:inventory) { create(:inventory, store:, shoe_model:, inventory: 10) }

  describe '#perform' do
    let(:batch) do
      [
        { 'store' => 'Test Store', 'model' => 'Test Model', 'inventory' => 20 }
      ]
    end

    it 'updates the inventory correctly' do
      service = InventoryUpdateService.new(batch)
      service.perform

      updated_inventory = Inventory.find(inventory.id)
      expect(updated_inventory.inventory).to eq(20)
    end

    it 'broadcasts the correct notification' do
      allow(ActionCable.server).to receive(:broadcast)

      service = InventoryUpdateService.new(batch)
      service.perform

      expect(ActionCable.server).to have_received(:broadcast).with(
        'notification_channel',
        store_name: 'Test Store',
        shoe_model: 'Test Model',
        inventory_count: 20
      )
    end

    context 'when an error occurs' do
      before do
        allow(Inventory).to receive(:where).and_raise(StandardError, 'Test error')
      end

      it 'logs the error' do
        expect { InventoryUpdateService.new(batch).perform }.to output(/Test error/).to_stdout
      end
    end
  end
end
