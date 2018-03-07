class ForecastTypesController < ApplicationController
  before_action :set_forecast_type, only: [:show, :update, :destroy]

  # GET /forecast_types
  def index
    @forecast_types = ForecastType.all

    render json: @forecast_types
  end

  # GET /forecast_types/1
  def show
    render json: @forecast_type
  end

  # POST /forecast_types
  def create
    @forecast_type = ForecastType.new(forecast_type_params)

    if @forecast_type.save
      render json: @forecast_type, status: :created, location: @forecast_type
    else
      render json: @forecast_type.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /forecast_types/1
  def update
    if @forecast_type.update(forecast_type_params)
      render json: @forecast_type
    else
      render json: @forecast_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /forecast_types/1
  def destroy
    if !@forecast_type.destroy
      render json: @forecast_type.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forecast_type
      @forecast_type = ForecastType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def forecast_type_params
      params.require(:forecast_type).permit(:atom, :label)
        .transform_keys {|key|
        case key
        when 'atom' then 'name'
        else
          key
        end
      }
    end
end
