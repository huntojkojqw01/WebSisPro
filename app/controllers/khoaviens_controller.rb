class KhoaviensController < ApplicationController
	before_action :logged_in_user
	before_action :is_admin, except: [:index,:show]
	before_action :set_x, only: [:edit,:update,:destroy]
	def index
		@khoaviens=Khoavien.all
	end
	def show
		@khoavien=Khoavien.find_by_id(params[:id])		
	end
	def new
		@khoavien=Khoavien.new
	end
	def edit				
	end
	def update
		if @khoavien.update(x_params)
	      	flash[:info]= t 'shared.updated'
	        redirect_to @khoavien
	    else
	    		flash.now[:danger]= t 'shared.notupdate'
	       	render 'edit'
	    end
  	end
	def create
		@khoavien=Khoavien.new(x_params)
		if @khoavien.save
	    flash[:success]= t 'shared.added'
	    redirect_to @khoavien
	  else
	  	flash.now[:danger]= t 'shared.notadd'
	    render 'new'
	  end
  end
  def destroy        	
  end    
	def import
		begin
			r=Khoavien.import(params[:file])    	
	    if r[0]
	      	flash[:success]= "File is imported(#{r[1]-1} record)."	      
	    else
			flash[:danger]= "エラ➖ #{r[1]}: #{r[2]}."			
	    end
	  rescue
	  	flash[:danger]= "Invalid CSV file format."
	  end
	  redirect_back fallback_location: khoaviens_path
	end
	private
	def set_x			
		unless params[:ids] || @khoavien=Khoavien.find_by_id(params[:id])
			flash[:danger]= t 'shared.notfound'
			redirect_to root_url
		end
	end
	def x_params
		params.require(:khoavien).permit(:tenkhoavien,:diadiem,:sodienthoai)
	end
end
