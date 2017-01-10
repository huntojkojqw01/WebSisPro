class LopsinhviensController < ApplicationController
	before_action :logged_in_user, except: [:index]
	before_action :is_admin, except: [:index]
	before_action :set_x, only: [:edit,:update]
	def index
		@selected=params.permit(:khoavien_id,:tenlopsinhvien)	
		@khoaviens=Khoavien.all
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			@lopsinhviens=Lopsinhvien.joins(:khoavien,:giaovien)
			.where("lopsinhviens.khoavien_id = ? and tenlopsinhvien like ?",@selected[:khoavien_id],"%#{@selected[:tenlopsinhvien]}%").select("lopsinhviens.*","tenkhoavien","tengiaovien").paginate(page: params[:page],:per_page=>10)
		else
			@lopsinhviens=Lopsinhvien.joins(:khoavien,:giaovien)
			.where("tenlopsinhvien like ?","%#{@selected[:tenlopsinhvien]}%").select("lopsinhviens.*","tenkhoavien","tengiaovien").paginate(page: params[:page],:per_page=>10)
		end		
		@lsvs = Lopsinhvien.all
        respond_to do |format|
          format.html
          format.csv { send_data @lsvs.as_csv }
      end
	end	
	def new
		@lopsinhvien = Lopsinhvien.new
	end
	def show
		@lopsinhvien=Lopsinhvien.joins(:khoavien,:giaovien).where("lopsinhviens.id=?",params[:id]).select("lopsinhviens.*","tenkhoavien","tengiaovien").first		
		@sinhviens=@lopsinhvien.sinhviens			
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
		@lopsinhvien=Lopsinhvien.find_by_id(params[:id])		
	end
	def x_params
	      params.require(:lopsinhvien).permit(:tenlopsinhvien,:giaovien_id,:khoahoc,:khoavien_id)
	end
	
end
