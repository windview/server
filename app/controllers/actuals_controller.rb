class ActualsController < ApplicationController
  before_action :set_actual, only: [:show, :update, :destroy]

  # GET /actuals
  def index
    @actuals = Actual
    if params['farm_id']
      farm = Farm.find(params['farm_id'])
      @actuals = @actuals.where(farm_id: farm.id)
    end

    if params['starting_at']
      @actuals = @actuals.where('timestamp >= ?', params[:starting_at])
    end

    if params['ending_at']
      @actuals = @actuals.where('timestamp <= ?', params[:ending_at])
    end

    limit = params['limit'] || 1000
    @actuals = @actuals.limit(limit)

    offset = params['offset'] || 0
    @actuals = @actuals.offset(offset)

    order_by = 'timestamp'
    if ['timestamp', 'actual_mw'].include?(params['order_by'])
      order_by = params['order_by']
    end

    order_dir = 'desc'
    if ['asc', 'desc'].include?(params['order_dir'])
      order_dir = params['order_dir']
    end
    @actuals = @actuals.order("#{order_by} #{order_dir}")

    render json: @actuals.all
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
