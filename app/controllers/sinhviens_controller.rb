class SinhviensController < ApplicationController
	include ApplicationHelper
	before_action :set_x, only: [:edit,:update,:show,:destroy,:thoikhoabieu,:bangdiem,:dangkilophoc]
	def index
		@selected=params
		@khoaviens=Khoavien.select("id,tenkhoavien")		
		@lopsinhviens=Lopsinhvien.select("id,tenlopsinhvien,khoavien_id")
		@sinhviens=Sinhvien.joins("inner join lopsinhviens on sinhviens.lopsinhvien_id=lopsinhviens.id").select("sinhviens.*,tenlopsinhvien,khoavien_id")
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			@lopsinhviens=@lopsinhviens.where("khoavien_id=#{@selected[:khoavien_id]}")
			@sinhviens=@sinhviens.where("khoavien_id=#{@selected[:khoavien_id]}")			
		else
		end
		if @selected[:lopsinhvien_id]&&@selected[:lopsinhvien_id]!=""
			@sinhviens=@sinhviens.where("lopsinhvien_id=#{@selected[:lopsinhvien_id]}")
		else
		end
		@sinhviens=@sinhviens.where("tensinhvien like ? and masinhvien like ?","%#{params[:tensinhvien]}%","%#{params[:masinhvien]}%")	
		@sinhviens=@sinhviens.order(tensinhvien: :desc).paginate(page: params[:page],:per_page=>10)
		@svs = Sinhvien.order :tensinhvien
        respond_to do |format|
          format.html
          format.csv { send_data @svs.as_csv }
      	end
	end
	
	def new
		@sinhvien = Sinhvien.new
	end
	def show		
		@lopsinhvien=@sinhvien.lopsinhvien			
	end
	def edit
		
	end
	def destroy
		user=@sinhvien.user
		@sinhvien.destroy
		if user!=nil
		      user.destroy
		end
		flash[:info]= 'Đã xóa .'
		redirect_to sinhviens_path
		end
	def update

	      if @sinhvien.update(x_params)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @sinhvien
	      else
	       	render 'edit'
	      end
  	end
	def create
		user=User.create!(name:x_params["masinhvien"],password:"123456",password_confirmation:"123456",loai:"sv")	      	
	    @sinhvien=Sinhvien.new(x_params)
		@sinhvien[:user_id]=user.id
	      	if @sinhvien.save
	      	flash[:success]= 'Tạo mới thành công .'
	        	redirect_to @sinhvien
	      	else
	        	render 'new'
	      	end
    	end
	
	def import
	    begin
	      Sinhvien.import(params[:file])
	      flash[:success]= "File is imported."
	      redirect_to sinhviens_path
	    rescue
			flash[:danger]= "Invalid CSV file format."
			redirect_to sinhviens_path
	    end
	end
	def thoikhoabieu
		@selected=params
		@lophocs=@sinhvien.lophocs.where("hocki_id=?",@selected[:hocki_id]) if @selected[:hocki_id]
		@hocki=Hocki.find_by_id(@selected[:hocki_id]) if @selected[:hocki_id]
	end
	def bangdiem
		@lophocs=@sinhvien.lophocs.order(hocki_id: :asc).paginate(page: params[:page],:per_page=>10)
	end
	def dangkilophoc
		@selected=params
		if(@selected[:lophoc_id]&&@selected[:id])
			dklh=Dangkilophoc.where("sinhvien_id=? and lophoc_id=?",@selected[:sinhvien_id],@selected[:lophoc_id])
			if dklh.count>0
				flash.now[:info]="Dang ki da ton tai."				
			else
				lophoc=Lophoc.find_by_id(@selected[:lophoc_id])				
				hocphan=lophoc.hocphan if lophoc				
				@selected[:hesohocphi]=@sinhvien.lophocs.where("hocphan_id=?",hocphan.id).count+1
				lophoc=Lophoc.find_by_id(@selected[:lophoc_id])
				hocki=lophoc.hocki
				tkb=getCurTkb(@sinhvien,hocki)
				if checkTkb(tkb,lophoc.thoigian)					
					@dangkilophoc=Dangkilophoc.new(sinhvien_id:@sinhvien.id,lophoc_id:lophoc.id,hesohocphi:@selected[:hesohocphi])
					if @dangkilophoc.save
				      	flash.now[:success]= 'Tạo mới thành công .'				        
				    else				        
				    end
				else					
					flash.now[:info]="Trung thoi khoa bieu."					
				end				
			end
		end	
		if @selected[:hocki_id]			
		@hocki=Hocki.find_by_id(@selected[:hocki_id]) 	
		else
		@hockis=Hocki.all
		end	
		@khoaviens=Khoavien.all		
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			if @selected[:hocki_id]&&@selected[:hocki_id]!=""
				@lophocs=Khoavien.find_by(id:@selected[:khoavien_id]).lophocs.where("hocki_id = ? and malophoc like ? and mahocphan like ?",@selected[:hocki_id],"%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
			else
				@lophocs=Khoavien.find_by(id:@selected[:khoavien_id]).lophocs.left_outer_joins(:hocphan).where("malophoc like ? and mahocphan like ?","%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
			end
		else
			if @selected[:hocki_id]&&@selected[:hocki_id]!=""
				@lophocs=Hocki.find_by(id:@selected[:hocki_id]).lophocs.left_outer_joins(:hocphan).where("malophoc like ? and mahocphan like ?","%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
			else
				@lophocs=Lophoc.left_outer_joins(:hocphan).where("malophoc like ? and mahocphan like ?","%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
			end		
		end		
		@lophocs=@lophocs.paginate(page: params[:page],:per_page=>20)
		@registeds=@sinhvien.lophocs.where("hocki_id=?",@selected[:hocki_id]) if @selected[:hocki_id]
	end
	private
	def set_x
		@sinhvien=Sinhvien.find_by_id(params[:id])
		if @sinhvien			
		else
			flash[:info]="Khong tim thay sinh vien."
			redirect_to root_url
		end	
	end
	def x_params
	      params.require(:sinhvien).permit(:masinhvien,:tensinhvien,:ngaysinh,:email,:trangthai,:lopsinhvien_id)
	end
	# Confirms the correct user.
	def correct_sinhvien
	      sinhvien = Sinhvien.find_by_id(params[:id])
	      unless current_user.sinhvien==sinhvien
	      	flash[:danger]="Bạn không phải là sinh vien đó !"
	      	redirect_to(root_url) 
	      end
	end	
	def danhGia(sinhvien,hocki)
		tcdat=tcdangki=tongdiem=0
		lophocs=sinhvien.lophocs.where("hocki_id=?",hocki.id)
		lophocs.each do |lh|
			dk=lh.dangkilophocs.find_by(sinhvien_id:sinhvien.id)
			tcdangki+=lh.hocphan.tinchi
			tcdat+=lh.hocphan.tinchi if dk.diemso && dk.diemso>=1.0
			tongdiem+=lh.hocphan.tinchi*dk.diemso if dk.diemso
		end
		return {mahocki: hocki.mahocki,tcdangki: tcdangki,tcdat: tcdat,gpa: tcdat>0 ? tongdiem/tcdangki : 0.0}
	end
end
