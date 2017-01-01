class DangkilophocsController < ApplicationController
	include ApplicationHelper
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index		
	end	
	def new
		@selected=params
		@dangkilophoc = Dangkilophoc.new		
	end
	def show		
								
	end
	def edit
		
	end
	def destroy
		@dangkilophoc.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to (:back)
		end
	def update
		pars=x_params
		lophoc=Lophoc.find_by_id(pars[:lophoc_id])
		hocki=lophoc.hocki
		hocphan=lophoc.hocphan if lophoc
		trongso=hocphan.trongso if hocphan
		pars[:diemquatrinh]=pars[:diemquatrinh].to_f
		pars[:diemthi]=pars[:diemthi].to_f		
		pars[:diemso]=diemso(pars[:diemquatrinh],pars[:diemthi],trongso)
		pars[:diemchu]=diemchu(pars[:diemso])
		sinhvien=Sinhvien.find_by_id(pars[:sinhvien_id])
		pars[:hesohocphi]=sinhvien.lophocs.where("hocphan_id=?",hocphan.id).count+1			
	      if @dangkilophoc.update(pars)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @dangkilophoc
	      else
	       	render 'edit'
	      end
  	end
	def create
		pars=x_params		
		if pars
			dklh=Dangkilophoc.where("sinhvien_id=? and lophoc_id=?",pars[:sinhvien_id],pars[:lophoc_id])
			if dklh.count>0
				flash[:info]="Dang ki da ton tai."
				redirect_to root_url
			else
				sinhvien=Sinhvien.find_by_id(pars[:sinhvien_id])
				lophoc=Lophoc.find_by_id(pars[:lophoc_id])				
				hocphan=lophoc.hocphan if lophoc				
				pars[:hesohocphi]=sinhvien.lophocs.where("hocphan_id=?",hocphan.id).count+1
				lophoc=Lophoc.find_by_id(pars[:lophoc_id])
				hocki=lophoc.hocki
				tkb=getCurTkb(sinhvien,hocki)
				if checkTkb(tkb,lophoc.thoigian)
					#p "khong trung"
					@dangkilophoc=Dangkilophoc.new(pars)
					if @dangkilophoc.save
				      	flash[:success]= 'Tạo mới thành công .'
				        redirect_to root_url
				    else
				        redirect_to root_url
				    end
				else
					#p "co trung"
					flash[:info]="Trung thoi khoa bieu."
					redirect_to root_url
				end				
			end
		else
			redirect_to root_url
		end
		
    end	
    def import
	    begin
	      count=Dangkilophoc.import(params[:file])
	      flash[:success]= "File is imported(#{count} records)."	      
	    rescue
			flash[:danger]= "Invalid CSV file format."			
	    end
	    redirect_to dangkilophocs_path
	end	
	private
	def set_x
		@dangkilophoc=Dangkilophoc.find_by_id(params[:id])
		if @dangkilophoc			
		else
			flash[:info]="Khong tim thay dang ki lop hoc nay."
			redirect_to root_url
		end	
	end
	def x_params
	    params.require(:dangkilophoc).permit(:sinhvien_id,:lophoc_id,:diemquatrinh,:diemthi)
	end
	def diemso(diemquatrinh,diemthi,trongso)
		return 0 if diemquatrinh<3.0 || diemthi<3.0
		diem=((1-trongso)*diemquatrinh+trongso*diemthi)
		if diem>=9.45			
			return 4.5
		elsif diem>=8.45
			return 4.0
		elsif diem>=7.95
			return 3.5
		elsif diem>=6.95
			return 3.0
		elsif diem>=6.45
			return 2.5
		elsif diem>=5.45
			return 2.0
		elsif diem>=4.95
			return 1.5
		elsif diem>=3.95
			return 1.0
		else
			return 0
		end
	end
	def diemchu(diemso)
		case diemso
		when 4.5
			return "A+"
		when 4
			return "A"
		when 3.5
			return "B+"
		when 3
			return "B"
		when 2.5
			return "C+"
		when 2
			return "C"
		when 1.5
			return "D+"
		when 1
			return "D"
		else
			return "F"	
		end			
	end	
end
