class LocaleController<ApplicationController
	def create
		session[:locale]=params[:locale].try(:to_sym)
		redirect_back fallback_location: root_path
	end
end