# frozen_string_literal: true

class InventoryUpdateService
  def initialize(batch)
    @batch = batch
  end

  def perform
    preload_data

    inventory_updates = []
    @batch.each do |data|
      store = @stores_cache[data['store']]
      shoe_model = @shoe_models_cache[data['model']]

      next unless store && shoe_model

      inventory = Inventory.find_by(store:, shoe_model:)
      next unless inventory

      inventory_updates << {
        id: inventory.id,
        inventory: data['inventory'],
        updated_at: Time.current
      }
    end

    bulk_update(inventory_updates) if inventory_updates.any?

    broadcast_notifications
  end

  private

  def preload_data
    store_names = @batch.map { |data| data['store'] }.uniq
    model_names = @batch.map { |data| data['model'] }.uniq

    @stores_cache = Store.where(name: store_names).index_by(&:name)
    @shoe_models_cache = ShoeModel.where(name: model_names).index_by(&:name)
  end

  def bulk_update(inventory_updates)
    inventory_updates.each do |update|
      Inventory.where(id: update[:id]).update_all(
        inventory: update[:inventory],
        updated_at: update[:updated_at]
      )
      puts "Updated inventory for ID: #{update[:id]}"
    rescue ActiveRecord::RecordNotFound => e
      puts "Record not found for ID: #{update[:id]}. Error: #{e.message}"
    rescue ActiveRecord::ActiveRecordError => e
      puts "ActiveRecord error while updating ID: #{update[:id]}. Error: #{e.message}"
    rescue StandardError => e
      puts "General error while updating ID: #{update[:id]}. Error: #{e.message}"
    end
  end

  def broadcast_notifications
    @batch.each do |data|
      ActionCable.server.broadcast('notification_channel', {
                                     store_name: data['store'],
                                     shoe_model: data['model'],
                                     inventory_count: data['inventory']
                                   })
    end
  end
end
