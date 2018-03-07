class ForecastsController < ApplicationController
  before_action :set_forecast, only: [:show, :update, :destroy]

  # GET /forecasts
  def index
    @forecasts = Forecast.all

    render json: @forecasts
  end

  # GET /forecasts/1
  def show
    render json: @forecast
  end

  # POST /forecasts
  def create
    @forecast = Forecast.new(forecast_params)

    if @forecast.save
      render json: @forecast, status: :created, location: @forecast
    else
      render json: @forecast.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /forecasts/1
  def update
    if @forecast.update(forecast_params)
      render json: @forecast
    else
      render json: @forecast.errors, status: :unprocessable_entity
    end
  end

  # DELETE /forecasts/1
  def destroy
    @forecast.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forecast
      @forecast = Forecast.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def forecast_params
      # NOTE AJA: have to permit! until rails supports permitting array of arrays
      params.require(:forecast)
        .permit!
        .transform_keys {|key|
          case key
          when 'provider_id' then 'forecast_provider_id'
          when 'provider_forecast_ref' then 'forecast_provider_forecast_ref'
          else
            key
          end
        }
        .tap {|p|
          if p.keys.include?('type')
            type_name = p.delete('type')
            forecast_type = ForecastType.where(name: type_name).first()
            p['forecast_type_id'] = (forecast_type ? forecast_type.id : nil)
          end
        }
    end
end
