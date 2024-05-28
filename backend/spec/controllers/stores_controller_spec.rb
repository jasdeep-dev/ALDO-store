# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  let!(:store) { create(:store) }

  let(:valid_attributes) do
    { name: 'New Store', address: '123 New Address' }
  end

  let(:invalid_attributes) do
    { name: nil, address: nil }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body).first['name']).to eq(store.name)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: store.to_param }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['id']).to eq(store.id)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Store' do
        expect do
          post :create, params: { store: valid_attributes }
        end.to change(Store, :count).by(1)
      end

      it 'renders a JSON response with the new store' do
        post :create, params: { store: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)['name']).to eq('New Store')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new store' do
        post :create, params: { store: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'Updated Store', address: '456 Updated Address' }
      end

      it 'updates the requested store' do
        put :update, params: { id: store.to_param, store: new_attributes }
        store.reload
        expect(store.name).to eq('Updated Store')
        expect(store.address).to eq('456 Updated Address')
      end

      it 'renders a JSON response with the store' do
        put :update, params: { id: store.to_param, store: valid_attributes }
        expect(response).to be_successful
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the store' do
        put :update, params: { id: store.to_param, store: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested store' do
      expect do
        delete :destroy, params: { id: store.to_param }
      end.to change(Store, :count).by(-1)
    end
  end
end
