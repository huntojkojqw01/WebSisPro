class KhoaviensController < ApplicationController
	before_action :logged_in_user
	before_action :is_admin
	def index
		@khoaviens=Khoavien.where("tenkhoavien like ?","%#{params[:tenkhoavien]}%").paginate(page: params[:page],per_page: 5)
	end
	def show
		@khoavien=Khoavien.find_by_id(params[:id])		
	end
	def import
		r=Khoavien.import(params[:file])    	
	    if r[0]
	      	flash[:success]= "File is imported(#{r[1]-1} record)."	      
	    else
			flash[:danger]= "エラ➖ #{r[1]}: #{r[2]}."			
	    end
	    redirect_to khoaviens_path
	end
end
