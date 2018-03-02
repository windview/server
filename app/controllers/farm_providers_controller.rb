class FarmProvidersController < ApplicationController
  before_action :set_farm_provider, only: [:show, :update, :destroy]

  # GET /farm_providers
  def index
    @farm_providers = FarmProvider.all.order('name asc')

    render json: @farm_providers
  end

  # GET /farm_providers/1
  def show
    render json: @farm_provider
  end

  # POST /farm_providers
  def create
    @farm_provider = FarmProvider.new(farm_provider_params)

    if @farm_provider.save
      render json: @farm_provider, status: :created, location: @farm_provider
    else
      render json: @farm_provider.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /farm_providers/1
  def update
    if @farm_provider.update(farm_provider_params)
      render json: @farm_provider
    else
      render json: @farm_provider.errors, status: :unprocessable_entity
    end
  end

  # DELETE /farm_providers/1
  def destroy
    @farm_provider.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_farm_provider
      @farm_provider = FarmProvider.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def farm_provider_params
      params.require(:farm_provider).permit(:atom, :label)
        .transform_keys {|key|
        case key
        when 'atom' then 'name'
        else
          key
        end
      }
    end
end
