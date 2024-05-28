# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

STORE_STORES = ['ALDO Centre Eaton', 'ALDO Destiny USA Mall', 'ALDO Pheasant Lane Mall', 'ALDO Holyoke Mall',
                'ALDO Maine Mall', 'ALDO Crossgates Mall', 'ALDO Burlington Mall', 'ALDO Solomon Pond Mall',
                'ALDO Auburn Mall', 'ALDO Waterloo Premium Outlets'].freeze
SHOES_MODELS = %w[ADERI MIRIRA CAELAN BUTAUD SCHOOLER SODANO MCTYRE CADAUDIA RASIEN WUMA
                  GRELIDIEN CADEVEN SEVIDE ELOILLAN BEODA VENDOGNUS ABOEN ALALIWEN GREG BOZZA].freeze
AMOUNT = Array(0..100)
amounts = AMOUNT.to_a

store_names = STORE_STORES.each.map do |store_name|
  {
    name: store_name,
    address: "address #{AMOUNT.sample}",
    created_at: Time.current,
    updated_at: Time.current
  }
end

shoe_model_names = SHOES_MODELS.map do |shoe_name|
  {
    name: shoe_name,
    price: AMOUNT.sample,
    created_at: Time.current,
    updated_at: Time.current
  }
end

Store.insert_all(store_names) unless store_names.empty?

ShoeModel.insert_all(shoe_model_names) unless shoe_model_names.empty?

stores = Store.all
shoe_models = ShoeModel.all

inventories_to_create = []

stores.each do |store|
  shoe_models.each do |model|
    next if Inventory.exists?(store_id: store.id, shoe_model_id: model.id)

    inventories_to_create << {
      store_id: store.id,
      # store_name: store.name,
      shoe_model_id: model.id,
      # shoe_model_name: model.name,
      inventory: amounts.sample,
      created_at: Time.current,
      updated_at: Time.current
    }
  end
end

Inventory.insert_all(inventories_to_create) unless inventories_to_create.empty?
