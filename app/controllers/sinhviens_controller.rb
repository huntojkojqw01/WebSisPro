class SinhviensController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user, except: [:index,:svdkh]
	before_action :is_admin, only: [:edit,:update,:new,:create,:destroy]	
	before_action :chinh_chu , only: [:show]
	before_action :set_x, only: [:edit,:update,:destroy]
	before_action :xx_params ,only: :duyet
	def index
		@sinhviens=Sinhvien.includes(lopsinhvien: :khoavien)		
	end	
	def new
		@sinhvien = Sinhvien.new
	end
	def show
		unless @sinhvien=Sinhvien.includes(:lopsinhvien).find_by_id(params[:id])			
			flash[:danger]="見付からない"
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
				@lophocs=Dangkilophoc.includes(lophoc: [:hocphan,:hocki])
						.where("sinhvien_id=? and diemchu!=?",@sinhvien.id,"")		
				@results={}
				hocphans={}
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
			flash[:info]= '削除しました'
			redirect_to sinhviens_path
		end
	end
	def update
	    if @sinhvien.update(update_params)
	      	flash[:info]='更新しました'
	        redirect_to @sinhvien
	    else
	       	render 'edit'
	    end
  	end
	def create
		@sinhvien=Sinhvien.new(x_params)
		user=User.create(name:@sinhvien[:masinhvien],password:"123456",password_confirmation:"123456",loai:"sv")
		if user.id
			@sinhvien[:user_id]=user.id			
			if @sinhvien.save				
				flash[:success]= '追加しました'
				redirect_to @sinhvien
			else
				user.destroy
				render 'new'
			end
		else
			flash[:danger]= 'アカウントを作成できない'
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
	def svdkh		
		if params[:masinhvien]
			if current_hocki		
				@hocki=Hocki.find_by_id(current_hocki.id)
			else
				@hocki=Hocki.find_by_id(last_hocki.id)
			end
			if @hocki 
				@sinhvien=Sinhvien.find_by(masinhvien: params[:masinhvien])
				if @sinhvien
					@lophocs=Dangkilophoc.joins(lophoc: :hocphan)
							.select("dangkilophocs.*","tinchihocphi*hesohocphi as tongphi")
							.where("hocki_id=? and sinhvien_id=?",@hocki.id,@sinhvien.id)
				else
					flash[:info]="見付からない"
				end			
			else
				flash[:info]="見付からない"					
			end
		end
	end	
	private
	def set_x
		unless params[:ids] || @sinhvien=Sinhvien.find_by_id(params[:id])
			flash[:info]="見付からない"	
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
	      flash[:danger]="あなたは本人じゃない"
	      redirect_to(root_url) 
	    end
    end
  end
end
