class SinhviensController < ApplicationController
	before_action :set_x, only: [:edit,:update,:show,:destroy]
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
	def show2
		@sinhvien=Sinhvien.find_by_id(params[:id])
		@lopsinhvien=@sinhvien.lopsinhvien		
		@bangdiems=Dangkilophoc.where("sinhvien_id=#{@sinhvien.id}").joins("inner join lophocs on lophoc_id=lophocs.id inner join hocphans on hocphan_id=hocphans.id inner join hockis on hocki_id=hockis.id").select("*")
		
		@selected=params
		@hockis=Hocki.order(mahocki: :asc)
		if @selected[:hocki_id]&&@selected[:hocki_id]!=""
			@dinhmuchocphi=Hocki.find_by_id(params[:hocki_id]).dinhmuchocphi		
			@tongtienphaidong=0
			@dangkilophocs=Dangkilophoc.joins("inner join lophocs on lophoc_id=lophocs.id inner join hocphans on hocphan_id=hocphans.id inner join hockis on hocki_id=hockis.id and lophocs.hocki_id=#{@selected[:hocki_id]} and sinhvien_id=#{@sinhvien.id}").select("*")
		else			
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
end
