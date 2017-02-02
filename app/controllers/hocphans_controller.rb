class HocphansController < ApplicationController
	before_action :logged_in_user, except: [:index]
	before_action :is_admin, except: [:index,:search]
	before_action :set_x, only: [:edit,:update,:destroy]
	def index		
		if params[:khoavien_id]&&params[:khoavien_id]!=""
			if params[:tinchi]&&params[:tinchi]!=""
				@hocphans=Hocphan.left_outer_joins(:khoavien)
				.where("khoavien_id=? and tinchi = ? and tenhocphan like ? and mahocphan like ?",params[:khoavien_id],params[:tinchi],"%#{params[:tenhocphan]}%","%#{params[:mahocphan]}%").select("hocphans.*","tenkhoavien").paginate(page: params[:page],:per_page=>10)
			else
				@hocphans=Hocphan.left_outer_joins(:khoavien)
				.where("khoavien_id=? and tenhocphan like ? and mahocphan like ?",params[:khoavien_id],"%#{params[:tenhocphan]}%","%#{params[:mahocphan]}%").select("hocphans.*","tenkhoavien").paginate(page: params[:page],:per_page=>10)
			end				
		else
			if params[:tinchi]&&params[:tinchi]!=""
				@hocphans=Hocphan.left_outer_joins(:khoavien)
				.where("tinchi = ? and tenhocphan like ? and mahocphan like ?",params[:tinchi],"%#{params[:tenhocphan]}%","%#{params[:mahocphan]}%").select("hocphans.*","tenkhoavien").paginate(page: params[:page],:per_page=>10)
			else
				@hocphans=Hocphan.left_outer_joins(:khoavien)
				.where("tenhocphan like ? and mahocphan like ?","%#{params[:tenhocphan]}%","%#{params[:mahocphan]}%").select("hocphans.*","tenkhoavien").paginate(page: params[:page],:per_page=>10)
			end
		end	
	end	
	def new
		@hocphan = Hocphan.new
	end
	def show		
		@hocphan=Hocphan.left_outer_joins(:khoavien).where("hocphans.id=?",params[:id])
				.select("hocphans.*","tenkhoavien").first			
	end
	def edit
		
	end
	def destroy
		@hocphan.destroy
		flash[:info]= 'Đã xóa .'
		redirect_back fallback_location: root_path
		end
	def update
	    if @hocphan.update(x_params)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @hocphan
	    else
	       	render 'edit'
	    end
  	end
	def create
		@hocphan=Hocphan.new(x_params)
		if @hocphan.save
	      	flash[:success]= 'Tạo mới thành công .'
	        redirect_to @hocphan
	    else
	        render 'new'
	    end
    end
    def search    		
    end
    def import
    	r=Hocphan.import(params[:file])    	
	    if r[0]
	      	flash[:success]= "File is imported(#{r[1]-1} record)."	      
	    else
			flash[:danger]= "Lỗi tại dòng thứ #{r[1]}: #{r[2]}."			
	    end
	    redirect_to new_hocphan_path
    end	
	private
	def set_x
		unless @hocphan=Hocphan.find_by_id(params[:id])
			flash[:info]="Không tìm thấy dữ liệu"	
			redirect_to root_url	
		end		
	end
	def x_params
	    params.require(:hocphan).permit(:mahocphan,:tenhocphan,:tinchi,:tinchihocphi,:trongso,:modangki,:khoavien_id)
	end	
end
