class DangkihocphansController < ApplicationController
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index		
	end	
	def new
		@dangkihocphan = Dangkihocphan.new
	end
	def show		
								
	end
	def edit
		
	end
	def destroy
		@dangkihocphan.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to dangkihocphans_path
		end
	def update

	      if @dangkihocphan.update(x_params)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @dangkihocphan
	      else
	       	render 'edit'
	      end
  	end
	def create
		@dangkihocphan=Dangkihocphan.new(x_params)
		if @dangkihocphan.save
	      	flash[:success]= 'Tạo mới thành công .'
	        redirect_to @dangkihocphan
	    else
	        render 'new'
	    end
    end	
	private
	def set_x
		@dangkihocphan=Dangkihocphan.find_by_id(params[:id])
		if @dangkihocphan			
		else
			flash[:info]="Khong tim thay dang ki hoc phan nay."
			redirect_to root_url
		end	
	end
	def x_params
	    params.require(:dangkihocphan).permit(:sinhvien_id,:hocphan_id,:hocki_id)
	end	
end
