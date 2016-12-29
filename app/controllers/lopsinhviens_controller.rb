class LopsinhviensController < ApplicationController
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index
		@selected=params		
		@khoaviens=Khoavien.all		
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			@lopsinhviens=Lopsinhvien.where("khoavien_id = ? and tenlopsinhvien like ?",@selected[:khoavien_id],"%#{@selected[:tenlopsinhvien]}%")
		else
			@lopsinhviens=Lopsinhvien.where("tenlopsinhvien like ?","%#{@selected[:tenlopsinhvien]}%")
		end
		@lopsinhviens=@lopsinhviens.order(tenlopsinhvien: :desc).paginate(page: params[:page],:per_page=>10)		
		@lsvs = Lopsinhvien.order :tenlopsinhvien
        respond_to do |format|
          format.html
          format.csv { send_data @lsvs.as_csv }
      end
	end	
	def new
		@lopsinhvien = Lopsinhvien.new
	end
	def show		
		@khoavien=@lopsinhvien.khoavien
		@giaovien=@lopsinhvien.giaovien
		@sinhviens=@lopsinhvien.sinhviens			
	end
	def edit
		
	end
	def destroy
		@lopsinhvien.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to lopsinhviens_path
		end
	def update

	      if @lopsinhvien.update(x_params)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @lopsinhvien
	      else
	       	render 'edit'
	      end
  	end
	def create
		@lopsinhvien=Lopsinhvien.new(x_params)
		if @lopsinhvien.save
	      	flash[:success]= 'Tạo mới thành công .'
	        redirect_to @lopsinhvien
	    else
	        render 'new'
	    end
    end	
	private
	def set_x
		@lopsinhvien=Lopsinhvien.find_by_id(params[:id])
		if @lopsinhvien			
		else
			flash[:info]="Khong tim thay lop sinh vien."
			redirect_to root_url
		end	
	end
	def x_params
	      params.require(:lopsinhvien).permit(:tenlopsinhvien,:giaovien_id,:khoahoc,:khoavien_id)
	end
	
end
