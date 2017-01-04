class HocphansController < ApplicationController
	before_action :logged_in_user, except: [:index]
	before_action :is_admin, except: [:index]
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index
		@selected=params		
		@khoaviens=Khoavien.order(:tenkhoavien)
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			if @selected[:tinchi]&&@selected[:tinchi]!=""
				@hocphans=Hocphan.where("khoavien_id=? and tinchi = ? and tenhocphan like ? and mahocphan like ?",@selected[:khoavien_id],@selected[:tinchi],"%#{@selected[:tenhocphan]}%","%#{@selected[:mahocphan]}%").order(:mahocphan).paginate(page: params[:page],:per_page=>10)
			else
				@hocphans=Hocphan.where("khoavien_id=? and tenhocphan like ? and mahocphan like ?",@selected[:khoavien_id],"%#{@selected[:tenhocphan]}%","%#{@selected[:mahocphan]}%").order(:mahocphan).paginate(page: params[:page],:per_page=>10)
			end				
		else
			if @selected[:tinchi]&&@selected[:tinchi]!=""
				@hocphans=Hocphan.where("tinchi = ? and tenhocphan like ? and mahocphan like ?",@selected[:tinchi],"%#{@selected[:tenhocphan]}%","%#{@selected[:mahocphan]}%").order(:mahocphan).paginate(page: params[:page],:per_page=>10)
			else
				@hocphans=Hocphan.where("tenhocphan like ? and mahocphan like ?","%#{@selected[:tenhocphan]}%","%#{@selected[:mahocphan]}%").order(:mahocphan).paginate(page: params[:page],:per_page=>10)
			end
		end				
		@hps =Hocphan.order :mahocphan
        respond_to do |format|
          format.html
          format.csv { send_data @hps.as_csv }
      end
	end	
	def new
		@hocphan = Hocphan.new
	end
	def show		
						
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
		if @hocphan			
		else
			flash[:info]="Khong tim thay hoc phan nay."
			redirect_to root_url
		end	
	end
	def x_params
	    params.require(:hocphan).permit(:mahocphan,:tenhocphan,:tinchi,:tinchihocphi,:trongso,:modangki,:khoavien_id)
	end	
end
