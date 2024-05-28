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

  describe '#bulk_update' do

    let(:batch) do
      [
        { 'store' => 'Store 1', 'model' => 'Model 1', 'inventory' => 10 },
        { 'store' => 'Store 2', 'model' => 'Model 2', 'inventory' => 20 }
      ]
    end
    let(:service) { InventoryUpdateService.new(batch) }

    before do
      # Stub preload_data method to set instance variables indirectly
      allow(Store).to receive(:where).with(name: ['Store 1', 'Store 2']).and_return([double(id: 1, name: 'Store 1'), double(id: 2, name: 'Store 2')])
      allow(ShoeModel).to receive(:where).with(name: ['Model 1', 'Model 2']).and_return([double(id: 1, name: 'Model 1'), double(id: 2, name: 'Model 2')])
      
      # Mock Inventory.find_by to return Inventory objects with appropriate ids
      allow(Inventory).to receive(:find_by).with(store: an_instance_of(Store), shoe_model: an_instance_of(ShoeModel)).and_return(double(id: 1), double(id: 2))
    end
    context 'when updates are successful' do
      it 'updates the inventory and prints a success message' do
        allow(Inventory).to receive(:where).with(id: 1).and_return(double(update_all: true))
        allow(Inventory).to receive(:where).with(id: 2).and_return(double(update_all: true))

        expect(service).to receive(:puts).with('Updated inventory for ID: 1')
        expect(service).to receive(:puts).with('Updated inventory for ID: 2')

        service.send(:bulk_update, [
          { id: 1, inventory: 10, updated_at: Time.current },
          { id: 2, inventory: 20, updated_at: Time.current }
        ])
      end
    end

    context 'when a RecordNotFound error occurs' do
      it 'rescues the error and prints a not found message' do
        allow(Inventory).to receive(:where).with(id: 1).and_raise(ActiveRecord::RecordNotFound, 'not found')

        expect(service).to receive(:puts).with('Record not found for ID: 1. Error: not found')

        service.send(:bulk_update, [
          { id: 1, inventory: 10, updated_at: Time.current }
        ])
      end
    end

    context 'when an ActiveRecordError occurs' do
      it 'rescues the error and prints an ActiveRecord error message' do
        allow(Inventory).to receive(:where).with(id: 1).and_raise(ActiveRecord::ActiveRecordError, 'active record error')

        expect(service).to receive(:puts).with('ActiveRecord error while updating ID: 1. Error: active record error')

        service.send(:bulk_update, [
          { id: 1, inventory: 10, updated_at: Time.current }
        ])
      end
    end

    context 'when a general error occurs' do
      it 'rescues the error and prints a general error message' do
        allow(Inventory).to receive(:where).with(id: 1).and_raise(StandardError, 'general error')

        expect(service).to receive(:puts).with('General error while updating ID: 1. Error: general error')

        service.send(:bulk_update, [
          { id: 1, inventory: 10, updated_at: Time.current }
        ])
      end
    end
  end

end
