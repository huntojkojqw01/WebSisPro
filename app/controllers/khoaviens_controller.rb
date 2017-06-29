class KhoaviensController < ApplicationController
	before_action :logged_in_user
	before_action :is_admin, except: :index
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
	      	flash[:info]='更新しました'
	        redirect_to @khoavien
	    else
	       	render 'edit'
	    end
  	end
	def create
		@khoavien=Hocphan.new(x_params)
		if @khoavien.save
	      	flash[:success]= '追加しました'
	        redirect_to @khoavien
	    else
	        render 'new'
	    end
    end
    def destroy        	
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
	private
	def set_x			
		unless params[:ids] || @khoavien=Khoavien.find_by_id(params[:id])
			flash[:info]="見付からない"
			redirect_to root_url
		end
	end
	def x_params
		params.require(:khoavien).permit(:tenkhoavien,:diadiem,:sodienthoai)
	end
end
