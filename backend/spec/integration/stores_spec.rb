# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Stores API', type: :request do
  path '/stores' do
    get 'Retrieves all stores' do
      tags 'Stores'
      produces 'application/json'

      response '200', 'stores found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   address: { type: :string, nullable: true },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 },
                 required: %w[id name created_at updated_at]
               }

        run_test!
      end
    end

    post 'Creates a store' do
      tags 'Stores'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :store, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          address: { type: :string, nullable: true }
        },
        required: ['name']
      }

      response '201', 'store created' do
        let(:store) { { name: 'New Store', address: '123 New Address' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:store) { { name: nil } }
        run_test!
      end
    end
  end

  path '/stores/{id}' do
    get 'Retrieves a store' do
      tags 'Stores'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'store found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 address: { type: :string, nullable: true },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               },
               required: %w[id name created_at updated_at]

        let(:id) { Store.create(name: 'Test Store', address: '123 Test Address').id }
        run_test!
      end

      response '404', 'store not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a store' do
      tags 'Stores'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :store, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          address: { type: :string, nullable: true }
        },
        required: ['name']
      }

      response '200', 'store updated' do
        let(:id) { Store.create(name: 'Test Store', address: '123 Test Address').id }
        let(:store) { { name: 'Updated Store', address: '456 Updated Address' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { Store.create(name: 'Test Store', address: '123 Test Address').id }
        let(:store) { { name: nil } }
        run_test!
      end
    end

    delete 'Deletes a store' do
      tags 'Stores'
      parameter name: :id, in: :path, type: :integer

      response '204', 'store deleted' do
        let(:id) { Store.create(name: 'Test Store', address: '123 Test Address').id }
        run_test!
      end
    end
  end
end
