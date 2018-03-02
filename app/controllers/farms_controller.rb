class FarmsController < ApplicationController
  before_action :set_farm, only: [:show, :update, :destroy]

  # GET /farms
  def index
    @farms = Farm.all.order('name ASC')

    render json: @farms
  end

  # GET /farms/1
  def show
    render json: @farm
  end

  # POST /farms
  def create
    @farm = Farm.new(farm_params)

    if @farm.save
      render json: @farm, status: :created, location: @farm
    else
      render json: @farm.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /farms/1
  def update
    if @farm.update(farm_params)
      render json: @farm
    else
      render json: @farm.errors, status: :unprocessable_entity
    end
  end

  # DELETE /farms/1
  def destroy
    @farm.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_farm
      @farm = Farm.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def farm_params
      params.require(:farm)
        .permit(:name, :provider_id, :provider_ref, :longitude, :latitude, :capacity_mw)
        .transform_keys {|key|
        case key
        when 'provider_id' then 'farm_provider_id'
        when 'provider_ref' then 'farm_provider_ref'
        when 'longitude' then 'lng'
        when 'latitude' then 'lat'
        else
          key
        end
      }
    end
end
