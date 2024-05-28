# frozen_string_literal: true

require 'test_helper'

class InventoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inventory = inventories(:one)
  end

  test 'should get index' do
    get inventories_url, as: :json
    assert_response :success
  end

  test 'should create inventory' do
    assert_difference('Inventory.count') do
      post inventories_url,
           params: { inventory: {
             inventory: @inventory.inventory,
             shoe_models_id: @inventory.shoe_models_id,
             store_id: @inventory.store_id
           } }, as: :json
    end

    assert_response :created
  end

  test 'should show inventory' do
    get inventory_url(@inventory), as: :json
    assert_response :success
  end

  test 'should update inventory' do
    patch inventory_url(@inventory),
          params: { inventory: {
            inventory: @inventory.inventory,
            shoe_models_id: @inventory.shoe_models_id,
            store_id: @inventory.store_id
          } }, as: :json
    assert_response :success
  end

  test 'should destroy inventory' do
    assert_difference('Inventory.count', -1) do
      delete inventory_url(@inventory), as: :json
    end

    assert_response :no_content
  end
end
