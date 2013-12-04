class ApplicationController < ActionController::Base
  protect_from_forgery

  def mixpanel
    options = {}
    @mixpanel ||= Mixpanel::Tracker.new(Figaro.env.MIXPANEL_TOKEN)
  end

  def authorize
    if current_user.is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end

end
