class KhoaviensController < ApplicationController
	before_action :logged_in_user
	before_action :is_admin
	def index
		@khoaviens=Khoavien.where("tenkhoavien like ?","%#{params[:tenkhoavien]}%").paginate(page: params[:page],per_page: 5)
	end
	def show
		@khoavien=Khoavien.find_by_id(params[:id])		
	end
end
