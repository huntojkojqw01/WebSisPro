class ChuongtrinhdaotaosController < ApplicationController
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index
		@ctdts=Chuongtrinhdaotao.all		
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
		redirect_to chuongtrinhdaotaos_path
		end
	def update

	      if @chuongtrinhdaotao.update(x_params)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @chuongtrinhdaotao
	      else
	       	render 'edit'
	      end
  	end
	def create
		@chuongtrinhdaotao=Chuongtrinhdaotao.new(x_params)
		if @chuongtrinhdaotao.save
	      	flash[:success]= 'Tạo mới thành công .'
	        redirect_to @chuongtrinhdaotao
	    else
	        render 'new'
	    end
    end	
	private
	def set_x
		@chuongtrinhdaotao=Chuongtrinhdaotao.find_by_id(params[:id])
		if @chuongtrinhdaotao			
		else
			flash[:info]="Khong tim thay dang ki hoc phan nay."
			redirect_to root_url
		end	
	end
	def x_params
	    params.require(:chuongtrinhdaotao).permit(:lopsinhvien_id,:hocphan_id,:hocki)
	end
end
