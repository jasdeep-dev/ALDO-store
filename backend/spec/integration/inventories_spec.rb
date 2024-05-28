# frozen_string_literal: true

require 'swagger_helper'
require 'kaminari'

RSpec.describe 'Inventories API', type: :request do
  path '/inventories' do
    get 'Retrieves all inventories' do
      tags 'Inventories'
      produces 'application/json'
      parameter name: :page, schema: { type: :string }, description: 'Page number'

      parameter name: :per_page, schema: { type: :string }, description: 'Items per page'

      response '200', 'inventories found' do
        schema type: :object,
               properties: {
                 inventories: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       store_id: { type: :integer },
                       shoe_model_id: { type: :integer },
                       inventory: { type: :integer },
                       created_at: { type: :string, format: 'date-time' },
                       updated_at: { type: :string, format: 'date-time' }
                     },
                     required: %w[id store_id shoe_model_id inventory created_at updated_at]
                   }
                 },
                 meta: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer },
                     next_page: { type: :integer, nullable: true },
                     prev_page: { type: :integer, nullable: true },
                     total_pages: { type: :integer },
                     total_count: { type: :integer }
                   }
                 }
               },
               required: %w[inventories meta]

        run_test!
      end
    end

    post 'Creates an inventory' do
      tags 'Inventories'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :inventory, in: :body, schema: {
        type: :object,
        properties: {
          store_id: { type: :integer },
          shoe_model_id: { type: :integer },
          inventory: { type: :integer }
        },
        required: %w[store_id shoe_model_id inventory]
      }

      response '201', 'inventory created' do
        let(:store) { create(:store) }
        let(:shoe_model) { create(:shoe_model) }
        let(:inventory) { { store_inventory: { store_id: store.id, shoe_model_id: shoe_model.id, inventory: 50 } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:inventory) { { store_inventory: { store_id: nil, shoe_model_id: nil, inventory: nil } } }
        run_test!
      end
    end
  end

  path '/inventories/{id}' do
    get 'Retrieves an inventory' do
      tags 'Inventories'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'inventory found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 store_id: { type: :integer },
                 shoe_model_id: { type: :integer },
                 inventory: { type: :integer },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               },
               required: %w[id store_id shoe_model_id inventory created_at updated_at]

        let(:id) { create(:inventory).id }
        run_test!
      end

      response '404', 'inventory not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates an inventory' do
      tags 'Inventories'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :inventory, in: :body, schema: {
        type: :object,
        properties: {
          store_id: { type: :integer },
          shoe_model_id: { type: :integer },
          inventory: { type: :integer }
        },
        required: %w[store_id shoe_model_id inventory]
      }

      response '200', 'inventory updated' do
        let(:store) { create(:store) }
        let(:shoe_model) { create(:shoe_model) }
        let(:id) { create(:inventory, store:, shoe_model:).id }
        let(:inventory) { { store_inventory: { store_id: store.id, shoe_model_id: shoe_model.id, inventory: 75 } } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { create(:inventory).id }
        let(:inventory) { { store_inventory: { store_id: nil, shoe_model_id: nil, inventory: nil } } }
        run_test!
      end
    end

    delete 'Deletes an inventory' do
      tags 'Inventories'
      parameter name: :id, in: :path, type: :integer

      response '204', 'inventory deleted' do
        let(:id) { create(:inventory).id }
        run_test!
      end
    end
  end
end
