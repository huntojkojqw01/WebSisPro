class ChuongtrinhdaotaosController < ApplicationController
	before_action :logged_in_user
	before_action :is_admin, only: [:new,:create,:destroy]
	before_action :set_x, only: [:show,:destroy]
	def index
		@ctdts=Chuongtrinhdaotao.left_outer_joins(:hocphan,:lopsinhvien)
		.select("chuongtrinhdaotaos.*","tenlopsinhvien","mahocphan")		
	end	
	def new
		@chuongtrinhdaotao = Chuongtrinhdaotao.new
	end
	def show		
								
	end
	def edit
		
	end
	def destroy
		@chuongtrinhdaotao.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to :back
		end
	def update
	    
  	end
	def create
		@chuongtrinhdaotao=Chuongtrinhdaotao.new(x_params)
		if @chuongtrinhdaotao.save
	      	flash[:success]= 'Tạo mới thành công .'
	        redirect_to chuongtrinhdaotaos_path
	    else
	        render 'new'
	    end
    end	
	private
	def set_x
		unless @chuongtrinhdaotao=Chuongtrinhdaotao.find_by_id(params[:id])	
			flash[:info]="Không tìm thấy dữ liệu"	
			redirect_to root_url	
		end
	end
	def x_params
	    params.require(:chuongtrinhdaotao).permit(:lopsinhvien_id,:hocphan_id,:hocki)
	end
end
