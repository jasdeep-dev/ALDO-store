# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Shoe Models API', type: :request do
  path '/shoe_models' do
    get 'Retrieves all shoe models' do
      tags 'Shoe Models'
      produces 'application/json'

      response '200', 'shoe models found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   price: { type: :number, format: :float },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 },
                 required: %w[id name price created_at updated_at]
               }

        run_test!
      end
    end

    post 'Creates a shoe model' do
      tags 'Shoe Models'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :shoe_model, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          price: { type: :number, format: :float }
        },
        required: %w[name price]
      }

      response '201', 'shoe model created' do
        let(:shoe_model) { { name: 'New Shoe Model', price: 99.99 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:shoe_model) { { name: nil, price: nil } }
        run_test!
      end
    end
  end

  path '/shoe_models/{id}' do
    get 'Retrieves a shoe model' do
      tags 'Shoe Models'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'shoe model found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 price: { type: :number, format: :float },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               },
               required: %w[id name price created_at updated_at]

        let(:id) { ShoeModel.create(name: 'Test Shoe Model', price: 99.99).id }
        run_test!
      end

      response '404', 'shoe model not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a shoe model' do
      tags 'Shoe Models'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :shoe_model, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          price: { type: :number, format: :float }
        },
        required: %w[name price]
      }

      response '200', 'shoe model updated' do
        let(:id) { ShoeModel.create(name: 'Test Shoe Model', price: 99.99).id }
        let(:shoe_model) { { name: 'Updated Shoe Model', price: 89.99 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { ShoeModel.create(name: 'Test Shoe Model', price: 99.99).id }
        let(:shoe_model) { { name: nil, price: nil } }
        run_test!
      end
    end

    delete 'Deletes a shoe model' do
      tags 'Shoe Models'
      parameter name: :id, in: :path, type: :integer

      response '204', 'shoe model deleted' do
        let(:id) { ShoeModel.create(name: 'Test Shoe Model', price: 99.99).id }
        run_test!
      end
    end
  end
end
