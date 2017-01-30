class GiaoviensController < ApplicationController
	before_action :logged_in_user
	before_action :is_admin
	before_action :set_x, only: [:edit,:update]
	def index		
		if params[:khoavien_id]&&params[:khoavien_id]!=""
			@giaoviens=Giaovien.joins(:khoavien)
			.where("khoavien_id = ? and tengiaovien like ?",params[:khoavien_id],"%#{params[:tengiaovien]}%").select("giaoviens.*","khoaviens.tenkhoavien").paginate(page: params[:page],:per_page=>10)
		else
			@giaoviens=Giaovien.joins(:khoavien)
			.where("tengiaovien like ?","%#{params[:tengiaovien]}%").select("giaoviens.*","khoaviens.tenkhoavien").paginate(page: params[:page],:per_page=>10)
		end		
	end	
	def new
		@giaovien = Giaovien.new
	end
	def show		
		@giaovien=Giaovien.joins(:khoavien).where("giaoviens.id=?",params[:id]).select("giaoviens.*","tenkhoavien").first			
	end
	def edit
		
	end
	def destroy
		
	end
	def update

	      if @giaovien.update(x_params)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @giaovien
	      else
	       	render 'edit'
	      end
  	end
	def create
		@giaovien=Giaovien.new(x_params)
		if @giaovien.save
	      	flash[:success]= 'Tạo mới thành công .'
	        redirect_to @giaovien
	    else
	        render 'new'
	    end
    end
    def search    	
    end
	private
	def set_x
		unless @giaovien=Giaovien.find_by_id(params[:id])	
			flash[:info]="Không tìm thấy dữ liệu"	
			redirect_to root_url
		end
	end
	def x_params
	    params.require(:giaovien).permit(:magiaovien,:tengiaovien,:ngaysinh,:email,:khoavien_id)
	end
	
end
