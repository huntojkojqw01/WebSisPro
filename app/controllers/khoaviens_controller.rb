class KhoaviensController < ApplicationController
	before_action :logged_in_user
	before_action :is_admin
	def index
		@selected=params.permit(:tenkhoavien)
		@khoaviens=Khoavien.where("tenkhoavien like ?","%#{@selected[:tenkhoavien]}%")
	end
	def show
		@khoavien=Khoavien.find_by_id(params[:id])		
	end

end
