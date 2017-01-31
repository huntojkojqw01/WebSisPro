class LopsinhviensController < ApplicationController
	before_action :logged_in_user, except: [:index]
	before_action :is_admin, except: [:index]
	before_action :set_x, only: [:edit,:update]
	def index
		if params[:khoavien_id]&&params[:khoavien_id]!=""
			@lopsinhviens=Lopsinhvien.joins(:khoavien,:giaovien)
			.where("lopsinhviens.khoavien_id = ? and tenlopsinhvien like ?",params[:khoavien_id],"%#{params[:tenlopsinhvien]}%").select("lopsinhviens.*","tenkhoavien","tengiaovien").paginate(page: params[:page],:per_page=>10)
		else
			@lopsinhviens=Lopsinhvien.joins(:khoavien,:giaovien)
			.where("tenlopsinhvien like ?","%#{params[:tenlopsinhvien]}%").select("lopsinhviens.*","tenkhoavien","tengiaovien").paginate(page: params[:page],:per_page=>10)
		end		
	end	
	def new
		@lopsinhvien = Lopsinhvien.new
	end
	def show
		@lopsinhvien=Lopsinhvien.joins(:khoavien,:giaovien).where("lopsinhviens.id=?",params[:id]).select("lopsinhviens.*","tenkhoavien","tengiaovien").first		
		unless @lopsinhvien
			flash[:info]="Không tìm thấy dữ liệu"	
			redirect_to root_url
		else
			@sinhviens=Sinhvien.joins(:lopsinhvien).select("sinhviens.*","tenlopsinhvien").where(lopsinhvien_id: @lopsinhvien.id).paginate(page: params[:page],per_page: 20)
		end					
	end
	def edit		
	end
	def destroy		
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
		unless @lopsinhvien=Lopsinhvien.find_by_id(params[:id])	
			flash[:info]="Không tìm thấy dữ liệu"	
			redirect_to root_url	
		end	
	end
	def x_params
	    params.require(:lopsinhvien).permit(:tenlopsinhvien,:giaovien_id,:khoahoc,:khoavien_id)
	end
	
end
