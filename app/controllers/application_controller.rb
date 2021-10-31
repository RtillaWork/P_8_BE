class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        before_action :configure_permitted_parameters, if: :devise_controller?
        # before_action :skip_trackable
       
        # NOTE: added to deactivate CSRF as API is supposed to be cross site
        # skip_before_action :verify_authenticity_token
        # A better solution for all controllers seems to be :null_session instead.
        # protect_from_forgery with: :null_session

        # include SetCurrentRequestDetails

        # def skip_trackable
        #   request.env['warden'].request.env['devise.skip_trackable'] = '1'
        # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :preferred_name, :avatar, :address, :gov_id, :default_lat, :default_lng, :last_active, :last_loggedin ])
    # NOTE no email update after creation as it is tied to account
    # Permit password update
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :preferred_name , :avatar, :address, :gov_id, :default_lat, :default_lng, :last_active, :last_loggedin])
  end
  
end