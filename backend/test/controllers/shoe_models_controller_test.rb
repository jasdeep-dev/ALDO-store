# frozen_string_literal: true

require 'test_helper'

class ShoeModelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shoe_model = shoe_models(:one)
  end

  test 'should get index' do
    get shoe_models_url, as: :json
    assert_response :success
  end

  test 'should create shoe_model' do
    assert_difference('ShoeModel.count') do
      post shoe_models_url, params: { shoe_model: { name: @shoe_model.name, price: @shoe_model.price } }, as: :json
    end

    assert_response :created
  end

  test 'should show shoe_model' do
    get shoe_model_url(@shoe_model), as: :json
    assert_response :success
  end

  test 'should update shoe_model' do
    patch shoe_model_url(@shoe_model), params: { shoe_model: { name: @shoe_model.name, price: @shoe_model.price } },
                                       as: :json
    assert_response :success
  end

  test 'should destroy shoe_model' do
    assert_difference('ShoeModel.count', -1) do
      delete shoe_model_url(@shoe_model), as: :json
    end

    assert_response :no_content
  end
end
