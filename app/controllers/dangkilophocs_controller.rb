class DangkilophocsController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user
	before_action :is_admin, only: [:edit,:update,:import]
	before_action :chinh_chu, only: [:new,:create,:destroy]
	before_action :set_x, only: [:destroy]
	before_action :not_permit, only: [:new,:create]
	def index
		@selected=params.permit(:malophoc,:masinhvien)	
		@dklhs=Dangkilophoc.joins({lophoc: :hocphan},:sinhvien)
		.where("malophoc like ? and masinhvien like ?","%#{@selected[:malophoc]}%","%#{@selected[:masinhvien]}%")
		.order("malophoc")
		.select("dangkilophocs.*","malophoc","masinhvien","trongso")
		.paginate(page: params[:page],:per_page=>10)
	end	
	def new		
		@dangkilophoc = Dangkilophoc.new			
	end
	def show		
		unless @dangkilophoc=Dangkilophoc.joins({lophoc: :hocphan},:sinhvien)
									.select("dangkilophocs.*","malophoc","tensinhvien")
									.find_by_id(params[:id])																	
			flash[:warning]="Không tìm thấy dữ liệu."
			redirect_to root_url
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
		flash.now[:info]= 'Đã xóa .'
		redirect_to (:back)
	end
	def update
		pars=update_params
		if @dangkilophoc=Dangkilophoc.joins({lophoc: :hocphan},:sinhvien)
									.select("dangkilophocs.*","trongso","hocphan_id","sinhvien_id")
									.find_by_id(params[:id])									
			tmp=tinhDiem(pars[:diemquatrinh],pars[:diemthi],@dangkilophoc.trongso)		
			pars[:diemso]=tmp[0]
			pars[:diemchu]=tmp[1]			
			pars[:hesohocphi]=Dangkilophoc.joins(:lophoc).where("hocphan_id=? and sinhvien_id=?",@dangkilophoc.hocphan_id,@dangkilophoc.sinhvien_id).count+1					
			if @dangkilophoc.update(pars)
			      		flash[:info]='Đã cập nhật .'
			      		redirect_to dangkilophocs_path	        	
			else
			    		flash.now[:danger]='Có lỗi khi cập nhật .'
			       		render 'edit'
			end		   
		else																	
			flash[:warning]="Không tìm thấy dữ liệu."
			redirect_to root_url
		end					    
  	end
	def create
		pars=create_params		
		if pars							
				sinhvien=Sinhvien.find_by_id(pars[:sinhvien_id])
				lophoc=Lophoc.find_by_id(pars[:lophoc_id])
				if sinhvien && lophoc			
					hocphan=lophoc.hocphan				
					pars[:hesohocphi]=sinhvien.lophocs.where("hocphan_id=?",hocphan.id).count+1					
						
						@dangkilophoc=Dangkilophoc.new(pars)
						r=dangkilophocOk(@dangkilophoc)
						if r.first
							if @dangkilophoc.save
						      	flash[:success]= 'Tạo mới thành công.'							      				        
						    else
						    	flash[:danger]= @dangkilophoc.errors.full_messages						    					        
						    end
						    redirect_to(:back)	
						else
							flash[:danger]= r.last
							redirect_to(:back)		    			
						end	
				else
					flash[:warning]= 'Không có sinh viên hoặc lớp học như vậy .'
					redirect_to(:back)
				end						
			
			
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
		unless @dangkilophoc=Dangkilophoc.find_by_id(params[:id])
			flash[:warning]="Không tìm thấy dữ liệu."
			redirect_to root_url
		end		
	end
	def update_params
	    params.require(:dangkilophoc).permit(:diemquatrinh,:diemthi)
	end
	def create_params
		params.require(:dangkilophoc).permit(:sinhvien_id,:lophoc_id)
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
	def not_permit
    	unless @hocki_modangkilophoc=Hocki.find_by_modangkilophoc(true)
    		flash[:danger]="Hiện không có học kì nào mở đăng kí lớp học"
    		redirect_to root_url 
    	end
    end
end
