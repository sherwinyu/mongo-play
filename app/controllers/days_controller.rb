class DaysController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    @recent_days = Day.recent

    respond_with @recent_days
    # @days  = Day.all
    # respond_with @days
  end

  def show
    @day = day
    if @day
      render json: @day
    else
      render json: @day, status: 404
    end
  end

  def create
    @day = Day.new date: params[:day][:date]
    if @day.save
      render json: @day
    else
      render json: @day.errors, status: :unprocessable_entity
    end
  end

  def update
    @day = day
    if @day.update_attributes params[:day]
      render json: nil, status: :no_content
    else
      render json: @day.errors, status: :unprocessable_entity
    end
  end

  def latest
    @day = Day.latest
    render json: @day
  end

  private
  def day
    Day.find_by(date: params[:id])
  end

end
