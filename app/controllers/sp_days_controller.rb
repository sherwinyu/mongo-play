class SpDaysController < ApplicationController
  respond_to :html, :json

  def index
    @spday  = SpDay.first
    respond_with [@spday]
  end

end

