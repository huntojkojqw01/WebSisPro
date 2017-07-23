class DangkilophocsController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user
	before_action :is_admin, only: [:new,:edit,:update,:import]
	before_action :chinh_chu, only: [:show,:create,:destroy]
	before_action :set_x, only: [:update,:destroy]
	before_action :not_permit, only: [:new,:create]	
	def index
		@dangkilophocs=Dangkilophoc.includes({lophoc: [:hocphan,:hocki]},:sinhvien)		
	end	
	def new
		@dangkilophoc = Dangkilophoc.new			
	end
	def show		
		@sinhvien=Sinhvien.find_by_id(params[:id])
		unless @sinhvien && @sinhvien==@current_sinhvien
			flash[:danger]= t 'c.shared.notself'
			redirect_to root_url
		else		
			if mo_dangki_lophoc?						
				@lophocs=@hocki_modangkilophoc.lophocs.includes(:hocphan).left_outer_joins(:dangkilophocs)
					.group(:id)
					.select("lophocs.*","count(dangkilophocs.id) as num_of_dklhs")						
				@registeds=Dangkilophoc.joins(lophoc: :hocphan)
					.where("sinhvien_id=? and hocki_id=?",@sinhvien.id,@hocki_modangkilophoc.id)
					.select("dangkilophocs.*","dangkilophocs.hesohocphi*hocphans.tinchihocphi as tongphi")
			else
				flash[:info]= t 'c.shared.noclass'
				redirect_to root_url
			end			
		end							
	end
	def edit		
		unless @dangkilophoc=Dangkilophoc.joins({lophoc: :hocphan},:sinhvien)
									.select("dangkilophocs.*","malophoc","masinhvien")
									.find_by_id(params[:id])																	
			flash[:warning]= t 'c.shared.notfound'
			redirect_to root_url
		end
	end
	def destroy
		@dangkilophoc.destroy
		flash[:info]= t 'c.shared.deleted'
		redirect_back fallback_location: root_path
	end
	def update
		if @dangkilophoc.update(update_params)
			flash[:info]= t 'c.shared.updated'			        	
		else
			flash[:danger]= t('c.shared.error') + @dangkilophoc.errors.full_messages.join(',')
		end
		redirect_back fallback_location: root_path					    
  	end
	def create
		@dangkilophoc=Dangkilophoc.new(create_params)
		if @dangkilophoc.save
			flash[:success]= t 'c.shared.added'							      				        
		else
			flash[:danger]= t('c.shared.error') + @dangkilophoc.errors.full_messages.join(',')					    					        
		end
		redirect_back fallback_location: root_path		
  end    	
  def import
  	begin
	    r=Dangkilophoc.import(params[:file])
	    if r[0]
	      flash[:success]= "File is imported(#{r[1]-1} record)."	      
	    else
				flash[:danger]= "エラ➖ #{r[1]}: #{r[2]}."			
	    end
	  rescue
	  	flash[:danger]= "Invalid CSV file format."
	  end
	  redirect_back fallback_location: root_path
	end	
	private
	def set_x
		unless @dangkilophoc=Dangkilophoc.find_by_id(params[:id])
			flash[:warning]= t 'c.shared.notfound'
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
          	flash[:danger]= t 'c.shared.notself'
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
    		flash[:danger]= t 'c.dangkilophocs.cantregister'
    		redirect_back fallback_location: dangkilophocs_path 
    	end
    end
end
