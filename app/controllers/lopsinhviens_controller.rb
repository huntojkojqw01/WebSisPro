class LopsinhviensController < ApplicationController
	before_action :logged_in_user, except: [:index]
	before_action :is_admin, except: [:index]
	before_action :set_x, only: [:edit,:update,:destroy]
	def index
		@lopsinhviens=Lopsinhvien.includes(:khoavien,:giaovien)
	end	
	def new
		@lopsinhvien = Lopsinhvien.new
	end
	def show
		@lopsinhvien=Lopsinhvien.includes(:khoavien,:giaovien).find_by_id(params[:id])
		if @lopsinhvien
			@sinhviens=@lopsinhvien.sinhviens
		else
			flash[:info]="見付からない"	
			redirect_to root_url		
		end					
	end
	def edit		
	end
	def destroy
		if params[:ids]
			params[:ids].each do |lopsinhvien_id|
				lopsinhvien=Lopsinhvien.find_by_id(lopsinhvien_id)
				if lopsinhvien
					lopsinhvien.destroy					
				end
			end			        
			respond_to do |f|
				f.json {render json: {destroy_success: 'success'}}				
			end
		else			
			@lopsinhvien.destroy			
			flash[:info]= '削除しました'
			redirect_to lopsinhviens_path
		end		
	end
	def update
	    if @lopsinhvien.update(x_params)
	      	flash[:info]='更新しました'
	        redirect_to @lopsinhvien
	    else
	       	render 'edit'
	    end
  	end
	def create
		@lopsinhvien=Lopsinhvien.new(x_params)
		if @lopsinhvien.save
	      	flash[:success]= '追加しました'
	        redirect_to @lopsinhvien
	    else
	        render 'new'
	    end
    end	
	private
	def set_x
		unless params[:ids] || @lopsinhvien=Lopsinhvien.find_by_id(params[:id])	
			flash[:info]="見付からない"	
			redirect_to root_url	
		end	
	end
	def x_params
	    params.require(:lopsinhvien).permit(:tenlopsinhvien,:giaovien_id,:khoahoc,:khoavien_id)
	end
	
end
