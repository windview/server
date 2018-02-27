class ForecastProvidersController < ApplicationController
  before_action :set_forecast_provider, only: [:show, :update, :destroy]

  # GET /forecast_providers
  def index
    @forecast_providers = ForecastProvider.all

    render json: @forecast_providers
  end

  # GET /forecast_providers/1
  def show
    render json: @forecast_provider
  end

  # POST /forecast_providers
  def create
    @forecast_provider = ForecastProvider.new(forecast_provider_params)

    if @forecast_provider.save
      render json: @forecast_provider, status: :created, location: @forecast_provider
    else
      render json: @forecast_provider.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /forecast_providers/1
  def update
    if @forecast_provider.update(forecast_provider_params)
      render json: @forecast_provider
    else
      render json: @forecast_provider.errors, status: :unprocessable_entity
    end
  end

  # DELETE /forecast_providers/1
  def destroy
    @forecast_provider.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forecast_provider
      @forecast_provider = ForecastProvider.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def forecast_provider_params
      params.require(:forecast_provider).permit(:name, :label)
    end
end
