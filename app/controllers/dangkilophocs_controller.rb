class DangkilophocsController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user
	before_action :is_admin, only: [:edit,:update,:import]
	before_action :chinh_chu, only: [:new,:create,:destroy]
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index
		@selected=params		
		@dklhs=Dangkilophoc.joins("inner join lophocs on dangkilophocs.lophoc_id=lophocs.id inner join sinhviens on dangkilophocs.sinhvien_id=sinhviens.id").where("malophoc like ? and masinhvien like ?","%#{@selected[:malophoc]}%","%#{@selected[:masinhvien]}%").order("lophocs.malophoc").paginate(page: params[:page],:per_page=>10)
	end	
	def new
		@selected=params
		@dangkilophoc = Dangkilophoc.new
		@sinhviens=Sinhvien.where(trangthai: true).order :masinhvien
		@lophocs=current_hocki_modklophoc.lophocs.order :malophoc		
	end
	def show		
								
	end
	def edit		
		@sinhviens=Sinhvien.where(trangthai: true).order :masinhvien
		@lophocs=current_hocki_modklophoc.lophocs.order :malophoc
	end
	def destroy
		@dangkilophoc.destroy
		flash.now[:info]= 'Đã xóa .'
		redirect_to (:back)
		end
	def update
		pars=x_params		
		dklh=Dangkilophoc.where("sinhvien_id=? and lophoc_id=?",pars[:sinhvien_id].to_i,pars[:lophoc_id].to_i)
		if dklh.count==0
			flash[:danger]="Đăng kí lớp học đó không tồn tại."
			redirect_to dangkilophocs_path				
		else
			lophoc=Lophoc.find_by_id(pars[:lophoc_id])
			sinhvien=Sinhvien.find_by_id(pars[:sinhvien_id])
			if sinhvien && lophoc				
				hocphan=lophoc.hocphan
				trongso=hocphan.trongso				
				tmp=tinhDiem(pars[:diemquatrinh],pars[:diemthi],trongso)		
				pars[:diemso]=tmp[0]
				pars[:diemchu]=tmp[1]			
				pars[:hesohocphi]=sinhvien.lophocs.where("hocphan_id=?",hocphan.id).count+1					
				if @dangkilophoc.update(pars)
		      		flash[:info]='Đã cập nhật .'
		      		redirect_to dangkilophocs_path	        	
		    	else
		    		flash.now[:danger]='Có lỗi khi cập nhật .'
		       		render 'edit'
		    	end
	    	else
	    		flash.now[:danger]='Không tồn tại sinh viên hoặc lớp học .'
	    		render 'edit'
	    	end

		end				    
  	end
	def create
		pars=x_params		
		if pars
			dklh=Dangkilophoc.where("sinhvien_id=? and lophoc_id=?",pars[:sinhvien_id].to_i,pars[:lophoc_id].to_i)
			if dklh.count>0
				flash[:info]="Đăng kí đã tồn tại."				
			else				
				sinhvien=Sinhvien.find_by_id(pars[:sinhvien_id])
				lophoc=Lophoc.find_by_id(pars[:lophoc_id])
				if sinhvien && lophoc			
					hocphan=lophoc.hocphan				
					pars[:hesohocphi]=sinhvien.lophocs.where("hocphan_id=?",hocphan.id).count+1					
						
						@dangkilophoc=Dangkilophoc.new(pars)
						r=dangkilophocOk(@dangkilophoc)
						if r.first
							if @dangkilophoc.save
						      	flash[:success]= 'Tạo mới thành công .'					        
						    else
						        flash[:warning]= 'Tạo mới thất bại .'
						    end
						else
							flash[:danger]= r.last		    			
						end	
				else
					flash[:warning]= 'Không có sinh viên hoặc lớp học như vậy .'
				end						
			end
			redirect_to(:back)
		else
			redirect_to root_url
		end
		
    end    	
    def import
	    r=Dangkilophoc.import(params[:file])
	    if r[0]
	      	flash[:success]= "File is imported(#{r[1]-1} record)."	      
	    else
			flash[:danger]= "Lỗi tại dòng thứ #{r[1]}: #{r[2]}."			
	    end
	    redirect_to(:back)
	end	
	private
	def set_x
		
			@dangkilophoc=Dangkilophoc.find_by_id(params[:id])
			if @dangkilophoc

			else
				flash[:danger]="Không tìm thấy dữ liệu"
				redirect_to root_url
			end
		
	end
	def x_params
	    params.require(:dangkilophoc).permit(:sinhvien_id,:lophoc_id,:diemquatrinh,:diemthi)
	end
	
	def chinh_chu
    	if sinhvien? && params[:dangkilophoc]  
        	unless current_sinhvien.id==params[:dangkilophoc][:sinhvien_id].to_i
          	flash[:danger]="Bạn không phải chính chủ !"
          	redirect_to(root_url) 
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
		elsif diem>=7.95
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
end
