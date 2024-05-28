# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventoriesController, type: :controller do
  let(:store) { create(:store) }
  let(:shoe_model) { create(:shoe_model) }
  let!(:inventory) { create(:inventory, store:, shoe_model:) }
  let!(:inventories) { create_list(:inventory, 9) }

  let(:valid_attributes) do
    { store_id: store.id, shoe_model_id: shoe_model.id, inventory: 50 }
  end

  let(:invalid_attributes) do
    { store_id: nil, shoe_model_id: nil, inventory: nil }
  end

  describe 'GET /inventories' do
    context 'when paginating results' do
      before do
        get :index, params: { page: 1, per_page: 2 }
      end

      it 'returns the first page of inventories' do
        expect(json['inventories'].size).to eq(2)
      end

      it 'returns pagination metadata' do
        expect(json['meta']).to include(
          'current_page' => 1,
          'next_page' => 2,
          'prev_page' => nil,
          'total_pages' => Inventory.count / 2,
          'total_count' => Inventory.count
        )
      end
    end

    context 'when requesting a specific page' do
      before do
        inventories
        get :index, params: { page: 2, per_page: 2 }
      end

      it 'returns the second page of inventories' do
        expect(json['inventories'].size).to eq(2)
      end

      it 'returns the correct pagination metadata' do
        expect(json['meta']).to include(
          'current_page' => 2,
          'next_page' => 3,
          'prev_page' => 1,
          'total_pages' => Inventory.count / 2,
          'total_count' => Inventory.count
        )
      end
    end

    context 'when requesting a non-existent page' do
      before { get :index, params: { page: 5, per_page: 2 } }

      it 'returns an empty result set' do
        expect(json['inventories'].size).to eq(2)
      end

      it 'returns the correct pagination metadata' do
        expect(json['meta']).to include(
          'current_page' => 5,
          'next_page' => nil,
          'prev_page' => 4,
          'total_pages' => 5,
          'total_count' => 10
        )
      end
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: inventory.to_param }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['id']).to eq(inventory.id)
    end
  end

  describe 'POST #create' do
    let(:new_store) { create(:store) }
    let(:new_shoe_model) { create(:shoe_model) }
    let(:prev_count) { Inventory.count }
    let(:attributes) do
      { store_id: new_store.id, shoe_model_id: new_shoe_model.id, inventory: 50 }
    end
    context 'with valid params' do
      it 'creates a new Inventory' do
        post :create, params: { store_inventory: attributes }
        expect(Inventory.count).to eq prev_count
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)['store_id']).to eq(new_store.id)
        expect(JSON.parse(response.body)['shoe_model_id']).to eq(new_shoe_model.id)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new inventory' do
        post :create, params: { store_inventory: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with missing params' do
      it 'renders a JSON response with errors for the new inventory' do
        post :create, params: { store_inventory: {} }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'permitted params' do
    it 'permits store_id, shoe_model_id, and inventory' do
      params = { store_inventory: { store_id: 1, shoe_model_id: 2, inventory: 10 } }
      should permit(:store_id, :shoe_model_id, :inventory)
        .for(:create, params:)
        .on(:store_inventory)
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { inventory: 75 }
      end

      it 'updates the requested inventory' do
        put :update, params: { id: inventory.to_param, store_inventory: new_attributes }
        inventory.reload
        expect(inventory.inventory).to eq(75)
      end

      it 'renders a JSON response with the inventory' do
        put :update, params: { id: inventory.to_param, store_inventory: valid_attributes }
        expect(response).to be_successful
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the inventory' do
        put :update, params: { id: inventory.to_param, store_inventory: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
    context 'with missing params' do
      it 'renders a JSON response with errors for the new inventory' do
        post :update, params: { id: inventory.to_param, store_inventory: {} }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested inventory' do
      expect do
        delete :destroy, params: { id: inventory.to_param }
      end.to change(Inventory, :count).by(-1)
    end
  end
end

def json
  JSON.parse(response.body)
end
