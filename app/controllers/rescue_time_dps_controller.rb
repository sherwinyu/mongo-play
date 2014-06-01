class RescueTimeDpsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!

  # GET /rescue_time_dps
  # GET /rescue_time_dps.json
  def index
    @rtdps = RescueTimeDp.most_recent
    if params[:refresh]
      rtdps, report = RescueTimeImporter.import
      ap report
      @rtdps.concat rtdps
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rtdps }
    end
  end

  # GET /rescue_time_dps/1
  # GET /rescue_time_dps/1.json
  def show
    @rtdp = RescueTimeDp.find(params[:id])
    if @data_point
      render json: @rtdp
    else
      render json: @rtdp, status: 404
    end
  end

end
