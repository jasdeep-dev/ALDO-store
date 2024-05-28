# frozen_string_literal: true

class ShoeModelsController < ApplicationController
  before_action :set_shoe_model, only: %i[show update destroy]

  # GET /shoe_models
  def index
    @shoe_models = ShoeModel.all

    render json: @shoe_models
  end

  # GET /shoe_models/1
  def show
    render json: @shoe_model
  end

  # POST /shoe_models
  def create
    @shoe_model = ShoeModel.new(shoe_model_params)

    if @shoe_model.save
      render json: @shoe_model, status: :created, location: @shoe_model
    else
      render json: @shoe_model.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shoe_models/1
  def update
    if @shoe_model.update(shoe_model_params)
      render json: @shoe_model
    else
      render json: @shoe_model.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shoe_models/1
  def destroy
    @shoe_model.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shoe_model
    @shoe_model = ShoeModel.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def shoe_model_params
    params.require(:shoe_model).permit(:name, :price)
  end
end
