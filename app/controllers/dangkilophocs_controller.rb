class DangkilophocsController < ApplicationController
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index		
	end	
	def new
		@dangkilophoc = Dangkilophoc.new
	end
	def show		
								
	end
	def edit
		
	end
	def destroy
		@dangkilophoc.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to dangkilophocs_path
		end
	def update
	      if @dangkilophoc.update(x_params)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @dangkilophoc
	      else
	       	render 'edit'
	      end
  	end
	def create
		@dangkilophoc=Dangkilophoc.new(x_params)
		if @dangkilophoc.save
	      	flash[:success]= 'Tạo mới thành công .'
	        redirect_to @dangkilophoc
	    else
	        render 'new'
	    end
    end	
	private
	def set_x
		@dangkilophoc=Dangkilophoc.find_by_id(params[:id])
		if @dangkilophoc			
		else
			flash[:info]="Khong tim thay dang ki lop hoc nay."
			redirect_to root_url
		end	
	end
	def x_params
	    params.require(:dangkilophoc).permit(:sinhvien_id,:lophoc_id,:trangthaidangki,:hesohocphi)
	end	
end
