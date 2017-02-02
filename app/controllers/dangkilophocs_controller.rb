class DangkilophocsController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user
	before_action :is_admin, only: [:new,:edit,:update,:import]
	before_action :chinh_chu, only: [:show,:create,:destroy]
	before_action :set_x, only: [:update,:destroy]
	before_action :not_permit, only: [:new,:create]	
	def index
		if params[:hocki_id]&&params[:hocki_id]!=''
			@dklhs=Dangkilophoc.joins({lophoc: :hocphan},:sinhvien)
				.where("hocki_id=? and malophoc like ? and masinhvien like ?",params[:hocki_id],"%#{params[:malophoc]}%","%#{params[:masinhvien]}%")
				.order("malophoc")
				.select("dangkilophocs.*","malophoc","masinhvien","trongso")
				.paginate(page: params[:page],:per_page=>10)
		else	
			@dklhs=Dangkilophoc.joins({lophoc: :hocphan},:sinhvien)
				.where("malophoc like ? and masinhvien like ?","%#{params[:malophoc]}%","%#{params[:masinhvien]}%")
				.order("malophoc")
				.select("dangkilophocs.*","malophoc","masinhvien","trongso")
				.paginate(page: params[:page],:per_page=>10)
		end
	end	
	def new		
		@dangkilophoc = Dangkilophoc.new			
	end
	def show		
		@sinhvien=Sinhvien.find_by_id(params[:id])
		unless @sinhvien && @sinhvien==@current_sinhvien
			flash[:info]="Không phải chính chủ"
			redirect_to root_url
		else		
			if mo_dangki_lophoc?						
				if params[:khoavien_id]&&params[:khoavien_id]!=""
					@lophocs=@hocki_modangkilophoc.lophocs.joins(:hocphan).left_outer_joins(:dangkilophocs)
							.where("khoavien_id = ? and malophoc like ? and mahocphan like ?",params[:khoavien_id],"%#{params[:malophoc]}%","%#{params[:mahocphan]}%")
							.group(:id,"mahocphan","tenhocphan")
							.select("lophocs.*","mahocphan","tenhocphan","count(dangkilophocs.id) as num_of_dklhs")
							.paginate(page: params[:page],:per_page=>10)			
				else
					@lophocs=@hocki_modangkilophoc.lophocs.joins(:hocphan).left_outer_joins(:dangkilophocs)
							.where("malophoc like ? and mahocphan like ?","%#{params[:malophoc]}%","%#{params[:mahocphan]}%")
							.group(:id,"mahocphan","tenhocphan")
							.select("lophocs.*","mahocphan","tenhocphan","count(dangkilophocs.id) as num_of_dklhs")
							.paginate(page: params[:page],:per_page=>10)
				end					
				@registeds=@sinhvien.dangkilophocs.joins(lophoc: :hocphan)
							.where("hocki_id=?",@hocki_modangkilophoc.id)							
							.select("dangkilophocs.*","malophoc","thoigian","diadiem","mahocphan","tenhocphan","tinchi","tinchihocphi","hesohocphi*tinchihocphi as tongphi")
			else
				flash[:info]="Không có học kì nào mở đăng kí"
				redirect_to root_url
			end			
		end							
	end
	def edit		
		unless @dangkilophoc=Dangkilophoc.joins({lophoc: :hocphan},:sinhvien)
									.select("dangkilophocs.*","malophoc","masinhvien")
									.find_by_id(params[:id])																	
			flash[:warning]="Không tìm thấy dữ liệu."
			redirect_to root_url
		end
	end
	def destroy
		@dangkilophoc.destroy
		flash[:info]= 'Đã xóa.'
		redirect_back fallback_location: root_path
	end
	def update
		if @dangkilophoc.update(update_params)
			flash[:info]='Đã cập nhật.'				        	
		else
			flash[:danger]='Thất bại: '+@dangkilophoc.errors.full_messages.join(',')
		end
		redirect_back fallback_location: root_path					    
  	end
	def create
		@dangkilophoc=Dangkilophoc.new(create_params)
		if @dangkilophoc.save
			flash[:success]= 'Tạo mới thành công.'							      				        
		else
			flash[:danger]= 'Tạo mới thất bại: '+@dangkilophoc.errors.full_messages.join(',')					    					        
		end
		redirect_back fallback_location: root_path		
    end    	
    def import
	    r=Dangkilophoc.import(params[:file])
	    if r[0]
	      	flash[:success]= "File is imported(#{r[1]-1} record)."	      
	    else
			flash[:danger]= "Lỗi tại dòng thứ #{r[1]}: #{r[2]}."			
	    end
	    redirect_back fallback_location: root_path
	end	
	private
	def set_x
		unless @dangkilophoc=Dangkilophoc.find_by_id(params[:id])
			flash[:warning]="Không tìm thấy dữ liệu."
			redirect_to root_url
		end		
	end
	def update_params
	    pars=params.require(:dangkilophoc).permit(:diemquatrinh,:diemthi)
	    hocphan=@dangkilophoc.lophoc.hocphan		
		tmp=tinhDiem(pars[:diemquatrinh],pars[:diemthi],hocphan.trongso) if hocphan		
		pars[:diemso],pars[:diemchu]=tmp[0],tmp[1]			
		return pars		
	end
	def create_params
		pars=params.require(:dangkilophoc).permit(:sinhvien_id,:lophoc_id)		
		lophoc=Lophoc.find_by_id(pars[:lophoc_id])
		hocphan=lophoc.hocphan	if lophoc			
		pars[:hesohocphi]=Dangkilophoc.joins(:lophoc).where("sinhvien_id=? and hocphan_id=?",pars[:sinhvien_id],hocphan.id).count+1 if hocphan	
		return pars
	end	
	def chinh_chu
    	if sinhvien? && params[:dangkilophoc]  
        	unless @current_sinhvien.id==params[:dangkilophoc][:sinhvien_id].to_i
          	flash[:danger]="Bạn không phải chính chủ !"
          	redirect_to root_url 
        	end
        end
    end	
    def tinhDiem(diemquatrinh,diemthi,trongso)
  		diemquatrinh=diemquatrinh.to_f
  		diemthi=diemthi.to_f
  		trongso=trongso.to_f
		return [0,"F"] if diemquatrinh<3.0 || diemthi<3.0
		diem=((1-trongso)*diemquatrinh+trongso*diemthi)
		if diem>=9.45			
			return [4,"A+"]
		elsif diem>=8.45
			return [4,"A"]
		elsif diem>7.95
			return [3.5,"B+"]
		elsif diem>=6.95
			return [3,"B"]
		elsif diem>=6.45
			return [2.5,"C+"]
		elsif diem>=5.45
			return [2,"C"]
		elsif diem>=4.95
			return [1.5,"D+"]
		elsif diem>=3.95
			return [1,"D"]
		else
			return [0,"F"]
		end
	end
	def not_permit
    	unless @hocki_modangkilophoc=Hocki.find_by_modangkilophoc(true)
    		flash[:danger]="Hiện không có học kì nào mở đăng kí lớp học"
    		redirect_to root_url 
    	end
    end
end
