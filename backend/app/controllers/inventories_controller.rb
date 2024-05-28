# frozen_string_literal: true

class InventoriesController < ApplicationController
  before_action :set_inventory, only: %i[show update destroy]

  # GET /inventories
  def index
    puts "params => #{params}"
    @inventories = Inventory.joins(:store, :shoe_model)
                            .select('inventories.*, stores.name as store_name, shoe_models.name as shoe_model_name')
                            .page(params[:page])
                            .per(params[:per_page] || 10)

    render json: {
      inventories: @inventories,
      meta: pagination_meta(@inventories)
    }
  end

  # GET /inventories/1
  def show
    render json: @inventory
  end

  # POST /inventories
  def create
    @inventory = Inventory.new(inventory_params)

    if @inventory.save
      render json: @inventory, status: :created, location: @inventory
    else
      render json: @inventory.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /inventories/1
  def update
    if @inventory.update(inventory_params)
      render json: @inventory
    else
      render json: @inventory.errors, status: :unprocessable_entity
    end
  end

  # DELETE /inventories/1
  def destroy
    @inventory.destroy
    head :no_content
  end

  private

  def set_inventory
    @inventory = Inventory.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Inventory not found with id #{params[:id]}" }, status: :not_found
  end

  def inventory_params
    params.require(:inventory).permit(:store_id, :shoe_model_id, :inventory)
  rescue ActionController::ParameterMissing
    render json: { error: 'Missing required inventory parameters' }, status: :unprocessable_entity
  end

  def pagination_meta(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_pages: object.total_pages,
      total_count: object.total_count
    }
  end
end
