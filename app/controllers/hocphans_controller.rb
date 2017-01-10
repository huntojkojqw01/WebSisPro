class HocphansController < ApplicationController
	before_action :logged_in_user, except: [:index]
	before_action :is_admin, except: [:index]
	before_action :set_x, only: [:edit,:update,:destroy]
	def index
		@selected=params.permit(:khoavien_id,:mahocphan,:tenhocphan,:tinchi)	
		@khoaviens=Khoavien.all
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			if @selected[:tinchi]&&@selected[:tinchi]!=""
				@hocphans=Hocphan.joins(:khoavien)
				.where("khoavien_id=? and tinchi = ? and tenhocphan like ? and mahocphan like ?",@selected[:khoavien_id],@selected[:tinchi],"%#{@selected[:tenhocphan]}%","%#{@selected[:mahocphan]}%").select("hocphans.*","tenkhoavien").paginate(page: params[:page],:per_page=>10)
			else
				@hocphans=Hocphan.joins(:khoavien)
				.where("khoavien_id=? and tenhocphan like ? and mahocphan like ?",@selected[:khoavien_id],"%#{@selected[:tenhocphan]}%","%#{@selected[:mahocphan]}%").select("hocphans.*","tenkhoavien").paginate(page: params[:page],:per_page=>10)
			end				
		else
			if @selected[:tinchi]&&@selected[:tinchi]!=""
				@hocphans=Hocphan.joins(:khoavien)
				.where("tinchi = ? and tenhocphan like ? and mahocphan like ?",@selected[:tinchi],"%#{@selected[:tenhocphan]}%","%#{@selected[:mahocphan]}%").select("hocphans.*","tenkhoavien").paginate(page: params[:page],:per_page=>10)
			else
				@hocphans=Hocphan.joins(:khoavien)
				.where("tenhocphan like ? and mahocphan like ?","%#{@selected[:tenhocphan]}%","%#{@selected[:mahocphan]}%").select("hocphans.*","tenkhoavien").paginate(page: params[:page],:per_page=>10)
			end
		end				
		@hps =Hocphan.all
        respond_to do |format|
          format.html
          format.csv { send_data @hps.as_csv }
      end
	end	
	def new
		@hocphan = Hocphan.new
	end
	def show		
		@hocphan=Hocphan.joins(:khoavien).where("hocphans.id=?",params[:id]).select("hocphans.*","tenkhoavien").first			
	end
	def edit
		
	end
	def destroy
		@hocphan.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to hocphans_path
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
	private
	def set_x
		@hocphan=Hocphan.find_by_id(params[:id])		
	end
	def x_params
	    params.require(:hocphan).permit(:mahocphan,:tenhocphan,:tinchi,:tinchihocphi,:trongso,:modangki,:khoavien_id)
	end	
end
