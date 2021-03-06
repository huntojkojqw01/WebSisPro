class SinhviensController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user, except: [:index,:show]
	before_action :is_admin, only: [:edit,:update,:new,:create,:destroy]	
	before_action :set_x, only: [:edit,:update,:destroy]	
	def index
		@sinhviens=Sinhvien.includes(lopsinhvien: :khoavien)		
	end	
	def new
		@sinhvien = Sinhvien.new
	end
	def show
		unless @sinhvien=Sinhvien.includes(:lopsinhvien).find_by_id(params[:id])			
			flash[:danger]= t 'shared.notfound'
			redirect_to sinhviens_path
		else
			if params[:hocki_id]
				@hocki=Hocki.find_by_id(params[:hocki_id])
				@lophocs=Dangkilophoc.joins(lophoc: :hocphan)					
						.where("hocki_id=? and sinhvien_id=?",params[:hocki_id],@sinhvien.id)
						.select("dangkilophocs.*","tinchihocphi*hesohocphi as tongphi")		
				respond_to do |f|				
					f.js
				end
			else
				if admin? || (sinhvien? && @current_sinhvien==@sinhvien)
					@lophocs=Dangkilophoc.includes(lophoc: [:hocphan,:hocki])
						.where("sinhvien_id=? and diemchu!=?",@sinhvien.id,"")		
					@results,hocphans={},{}					
					@lophocs.each do |lh|
						if @results.key? lh.mahocki
							@results["#{lh.mahocki}"][:tcdkKI]+=lh.tinchi
							@results["#{lh.mahocki}"][:tcqKI]+=lh.diemso>0 ? lh.tinchi : 0
							@results["#{lh.mahocki}"][:diemki]+=lh.diemso*lh.tinchi
							if hocphans.key? lh.mahocphan
								diemcu=	hocphans["#{lh.mahocphan}"][:diemcu]			
								@results["#{lh.mahocki}"][:tcdkKI_thucte]+=0
								@results["#{lh.mahocki}"][:tcqKI_thucte]+= diemcu <=0 ? lh.tinchi : 0
								@results["#{lh.mahocki}"][:diemki_thucte]+= lh.diemso>diemcu ? (lh.diemso-diemcu)*lh.tinchi : 0
								hocphans["#{lh.mahocphan}"][:diemcu]=lh.diemso if diemcu<lh.diemso
							else
								@results["#{lh.mahocki}"][:tcdkKI_thucte]+=lh.tinchi
								@results["#{lh.mahocki}"][:tcqKI_thucte]+= lh.diemso>0 ? lh.tinchi : 0
								@results["#{lh.mahocki}"][:diemki_thucte]+= lh.diemso*lh.tinchi
								hocphans["#{lh.mahocphan}"]={diemcu: lh.diemso}
							end				
						else #if @results.key? lh.mahocki
							@results["#{lh.mahocki}"]={
								tcdkKI: lh.tinchi,
								tcqKI: lh.diemso>0 ? lh.tinchi : 0,
								diemki: lh.diemso*lh.tinchi,								
							}
							if hocphans.key? lh.mahocphan
								diemcu=	hocphans["#{lh.mahocphan}"][:diemcu]			
								@results["#{lh.mahocki}"][:tcdkKI_thucte]=0
								@results["#{lh.mahocki}"][:tcqKI_thucte]= diemcu <=0 ? lh.tinchi : 0
								@results["#{lh.mahocki}"][:diemki_thucte]= lh.diemso>diemcu ? (lh.diemso-diemcu)*lh.tinchi : 0
								hocphans["#{lh.mahocphan}"][:diemcu]=lh.diemso if diemcu<lh.diemso
							else
								@results["#{lh.mahocki}"][:tcdkKI_thucte]=lh.tinchi
								@results["#{lh.mahocki}"][:tcqKI_thucte]= lh.diemso>0 ? lh.tinchi : 0
								@results["#{lh.mahocki}"][:diemki_thucte]= lh.diemso*lh.tinchi
								hocphans["#{lh.mahocphan}"]={diemcu: lh.diemso}
							end					
						end# if @results.key? lh.mahocki						
					end# @lophocs.each do |lh|
					tongTCdangki=tongTCqua=tongDiem=0
					@results.each do |key,val|
						tongDiem+=val[:diemki_thucte]
						tongTCdangki+=val[:tcdkKI_thucte]
						tongTCqua+=val[:tcqKI_thucte]
						val[:gpa]=(val[:diemki]/val[:tcdkKI]).round(2)
						val[:cpa]=(tongDiem/tongTCdangki).round(2)
						val[:tcdkKH]=tongTCdangki
						val[:tcqKH]=tongTCqua
					end# @results.each do |key,val|
				else
					@lophocs=@results=nil
				end# if sinhvien? && @current_sinhvien==@sinhvien
			end# if params[:hocki_id]
		end# unless @sinhvien=
	end
	def edit		
	end
	def destroy
		if params[:ids]
			params[:ids].each do |sinhvien_id|
				sinhvien=Sinhvien.find_by_id(sinhvien_id)
				if sinhvien
					user=sinhvien.user
					sinhvien.destroy
					if user!=nil
					    user.destroy
					end
				end
			end			        
			respond_to do |f|
				f.json {render json: {destroy_success: 'success'}}				
			end
		else		
			user=@sinhvien.user
			@sinhvien.destroy
			if user!=nil
			    user.destroy
			end
			flash[:info]= t 'shared.deleted'
			redirect_to sinhviens_path
		end
	end
	def update
	    if @sinhvien.update(update_params)
	      	flash[:info]= t 'shared.updated'
	        redirect_to @sinhvien
	    else
	    		flash.now[:danger]= t 'shared.notupdate'
	       	render 'edit'
	    end
  	end
	def create
		@sinhvien=Sinhvien.new(x_params)
		user=User.create(name:@sinhvien[:masinhvien],password:"123456",password_confirmation:"123456",loai:"sv")
		if user.id
			@sinhvien[:user_id]=user.id			
			if @sinhvien.save				
				flash[:success]= t 'shared.added'
				redirect_to @sinhvien
			else
				user.destroy
				flash.now[:danger]= t 'shared.notadd'
				render 'new'
			end
		else
			flash.now[:danger]= t '.cantcreateuser'
			render 'new'
		end		    
	end	
	def import
		begin
	    r=Sinhvien.import(params[:file])
	    if r[0]
	      	flash[:success]= "File is imported(#{r[1]-1} record)."	      
	    else
			flash[:danger]= "エラ➖ #{r[1]}: #{r[2]}."			
	    end
	  rescue
	  	flash[:danger]= "Invalid CSV file format."
	  end
	  redirect_back fallback_location: sinhviens_path
	end	
	private
	def set_x
		unless params[:ids] || @sinhvien=Sinhvien.find_by_id(params[:id])
			flash[:danger]= t 'shared.notfound'
			redirect_to root_url	
		end
	end
	def update_params
	  params.require(:sinhvien).permit(:tensinhvien,:ngaysinh,:email,:trangthai,:lopsinhvien_id)
	end	
	def x_params
	  params.require(:sinhvien).permit(:masinhvien,:tensinhvien,:ngaysinh,:email,:trangthai,:lopsinhvien_id)
	end	
	def chinh_chu
    if sinhvien?  
	    unless @current_sinhvien.id==params[:id].to_i
	      flash[:danger]= t 'shared.notself'
	      redirect_to(root_url) 
	    end
    end
  end
end
