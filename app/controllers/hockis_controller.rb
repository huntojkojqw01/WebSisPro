class HockisController < ApplicationController
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index
		@hockis=Hocki.order(mahocki: :desc).paginate(page: params[:page],:per_page=>10)			
	end	
	def new
		@hocki = Hocki.new
	end
	def show		
						
	end
	def edit
		
	end
	def destroy
		@hocki.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to hockis_path
		end
	def update

	      if @hocki.update(x_params)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @hocki
	      else
	       	render 'edit'
	      end
  	end
	def create
		@hocki=Hocki.new(x_params)
		if @hocki.save
	      	flash[:success]= 'Tạo mới thành công .'
	        redirect_to @hocki
	    else
	        render 'new'
	    end
    end	
	private
	def set_x
		@hocki=Hocki.find_by_id(params[:id])
		if @hocki			
		else
			flash[:info]="Khong tim thay hoc ki."
			redirect_to root_url
		end	
	end
	def x_params
	      params.require(:hocki).permit(:mahocki,:dinhmuchocphi)
	end
end
