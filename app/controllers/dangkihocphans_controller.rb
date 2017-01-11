class DangkihocphansController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user
	before_action :chinh_chu
	before_action :set_x, only: [:show,:destroy]
	before_action :not_permit ,only: [:new,:create]
	def index		
	end	
	def new
		@dangkihocphan = Dangkihocphan.new
	end
	def show		
								
	end
	def edit
		
	end
	def destroy
		@dangkihocphan.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to dangkihocphans_path
		end
	def update

  	end
	def create
		pars=x_params		
		if pars
			dkhp=Dangkihocphan.where("sinhvien_id=? and hocphan_id=? and hocki_id=?",pars[:sinhvien_id].to_i,pars[:hocphan_id].to_i,pars[:hocki_id].to_i)
			if dkhp.count>0
				flash[:info]="Dang ki da ton tai."				
			else				
					@dangkihocphan=Dangkihocphan.new(pars)
					r=dangkihocphanOk(@dangkihocphan)
					if r.first
						if @dangkihocphan.save
					      	flash[:success]= 'Tạo mới thành công .'					        
					    else
					        flash[:warning]= 'Tạo mới that bai .'
					    end
					else
						flash[:danger]= r.last		    			
					end							
			end
			redirect_to(:back)
		else
			redirect_to root_url
		end
    end	
	private
	def set_x
		unless @dangkihocphan=Dangkihocphan.find_by_id(params[:id])		
			flash[:info]="Không tìm thấy dữ liệu ."
			redirect_to root_url
		end	
	end
	def x_params
	    params.require(:dangkihocphan).permit(:sinhvien_id,:hocphan_id,:hocki_id)
	end	
	def chinh_chu
    	if sinhvien? && params[:dangkihocphan]  
        unless current_sinhvien.id==params[:dangkihocphan][:sinhvien_id].to_i
          flash[:danger]="Bạn không phải chính chủ !"
          redirect_to(root_url) 
        end
        end
    end
    def not_permit
    	unless @hocki_modangkihocphan=Hocki.find_by_modangkihocphan(true)
    		flash[:danger]="Hiện không có học kì nào mở đăng kí học phần"
    		redirect_to root_url 
    	end
    end
end
