class KhoaviensController < ApplicationController
	def index
		@selected=params
		@khoaviens=Khoavien.where("tenkhoavien like ?","%#{@selected[:tenkhoavien]}%")		
	end
	def show
		@khoavien=Khoavien.find_by_id(params[:id])		
	end
end
