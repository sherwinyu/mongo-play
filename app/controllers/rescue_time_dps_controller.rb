class RescueTimeDpsController < ApplicationController
  respond_to :html, :json

  # GET /rescue_time_dps
  # GET /rescue_time_dps.json
  def index
    @rtdps = RescueTimeDp.cached_recent
    if params[:refresh]
      rtdpN = RescueTimeDp.new activities: {im_new: {duration: 3000, productivity: 2, category: "NEW"}}, id: "zug"
      rtdpN.time = Time.now
      @rtdps << rtdpN
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
