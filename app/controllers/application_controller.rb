class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!, except: [:start]
  before_action :set_locale
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :language) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :language) }
  end
  
  def set_locale
    I18n.locale = extract_locale_from_user || I18n.default_locale
  end
  
  def extract_locale_from_user
    if user_signed_in? then
      current_user.language
    else
      #Ohne Anmeldung ermitteln wir die Sprache aus den Browsereinstellungen
      env = request.env['HTTP_ACCEPT_LANGUAGE']
      if env then
        env.scan(/^[a-z]{2}/).first
      else
        I18n.default_locale
      end
    end
  end
  
end
