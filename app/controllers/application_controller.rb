class ApplicationController < ActionController::Base
	include SessionsHelper 
  protect_from_forgery with: :exception
  before_action :set_locale

	def set_locale
	  I18n.locale = session[:locale] || I18n.default_locale unless session[:locale]==""
	end   
end
