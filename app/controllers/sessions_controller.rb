class SessionsController < Devise::SessionsController
  respond_to :json

  def destroy
    binding.pry
=begin
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      render json: {
        'csrf-param' => request_forgery_protection_token,
        'csrf-token' => form_authenticity_token
      }
    signed_out =
=end
  end

end
