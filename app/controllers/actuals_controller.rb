class ActualsController < ApplicationController
  before_action :set_actual, only: [:show, :update, :destroy]

  # GET /actuals
  def index
    @actuals = Actual.all

    render json: @actuals
  end

  # GET /actuals/1
  def show
    render json: @actual
  end

  # POST /actuals
  def create
    @actual = Actual.new(actual_params)

    if @actual.save
      render json: @actual, status: :created, location: @actual
    else
      render json: @actual.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /actuals/1
  def update
    if @actual.update(actual_params)
      render json: @actual
    else
      render json: @actual.errors, status: :unprocessable_entity
    end
  end

  # DELETE /actuals/1
  def destroy
    @actual.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_actual
      @actual = Actual.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def actual_params
      params.require(:actual).permit(:farm_id, :timestamp, :actual_mw)
    end
end
