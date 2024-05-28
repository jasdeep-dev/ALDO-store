# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoeModelsController, type: :controller do
  let!(:shoe_model) { create(:shoe_model) }

  let(:valid_attributes) do
    { name: 'New Model', price: 99.99 }
  end

  let(:invalid_attributes) do
    { name: nil, price: nil }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body).first['name']).to eq(shoe_model.name)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: shoe_model.to_param }
      expect(response).to be_successful
      expect(JSON.parse(response.body)['id']).to eq(shoe_model.id)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new ShoeModel' do
        expect do
          post :create, params: { shoe_model: valid_attributes }
        end.to change(ShoeModel, :count).by(1)
      end

      it 'renders a JSON response with the new shoe_model' do
        post :create, params: { shoe_model: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)['name']).to eq('New Model')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new shoe_model' do
        post :create, params: { shoe_model: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'Updated Model', price: 199.99 }
      end

      it 'updates the requested shoe_model' do
        put :update, params: { id: shoe_model.to_param, shoe_model: new_attributes }
        shoe_model.reload
        expect(shoe_model.name).to eq('Updated Model')
        expect(shoe_model.price).to eq(199.99)
      end

      it 'renders a JSON response with the shoe_model' do
        put :update, params: { id: shoe_model.to_param, shoe_model: valid_attributes }
        expect(response).to be_successful
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the shoe_model' do
        put :update, params: { id: shoe_model.to_param, shoe_model: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested shoe_model' do
      expect do
        delete :destroy, params: { id: shoe_model.to_param }
      end.to change(ShoeModel, :count).by(-1)
    end
  end
end
