class ForecastsController < ApplicationController
  before_action :set_forecast, only: [:show, :update, :destroy]

  # GET /forecasts
  def index
    @forecasts = Forecast
    if params['farm_id']
      farm = Farm.find(params['farm_id'])
      @forecasts = @forecasts.where(farm_id: farm.id)
    end
    if params['provider_id']
      forecast_provider = ForecastProvider.find(params['provider_id'])
      @forecasts = @forecasts.where(forecast_provider_id: forecast_provider.id)
    end
    if params['type']
      forecast_type = ForecastType.find_by!(name: params['type'])
      @forecasts = @forecasts.where(forecast_type_id: forecast_type.id)
    end
    if params['horizon_minutes']
      @forecasts = @forecasts.where(horizon_minutes: params['horizon_minutes'])
    end
    limit = params['limit'] || 1000
    @forecasts = @forecasts.limit(limit)

    offset = params['offset'] || 0
    @forecasts = @forecasts.offset(offset)

    order_by = 'generated_at'
    if ['generated_at', 'begins_at'].include?(params['order_by'])
      order_by = params['order_by']
    end

    order_dir = 'desc'
    if ['asc', 'desc'].include?(params['order_dir'])
      order_dir = params['order_dir']
    end

    @forecasts = @forecasts.order("#{order_by} #{order_dir}")

    render json: @forecasts.all
  end

  # GET /forecasts/latest
  def latest
    @forecasts = Forecast.order('generated_at DESC').limit(1)
    if params['farm_id']
      farm = Farm.find(params['farm_id'])
      @forecasts = @forecasts.where(farm_id: farm.id)
    end
    if params['provider_id']
      forecast_provider = ForecastProvider.find(params['provider_id'])
      @forecasts = @forecasts.where(forecast_provider_id: forecast_provider.id)
    end
    if params['type']
      forecast_type = ForecastType.find_by!(name: params['type'])
      @forecasts = @forecasts.where(forecast_type_id: forecast_type.id)
    end

    render json: @forecasts.first
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
