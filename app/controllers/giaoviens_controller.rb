class GiaoviensController < ApplicationController
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index
		@selected=params		
		@khoaviens=Khoavien.all		
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			@giaoviens=Giaovien.where("khoavien_id = ? and tengiaovien like ?",@selected[:khoavien_id],"%#{@selected[:tengiaovien]}%")
		else
			@giaoviens=Giaovien.where("tengiaovien like ?","%#{@selected[:tengiaovien]}%")
		end
		@giaoviens=@giaoviens.order(tengiaovien: :desc).paginate(page: params[:page],:per_page=>10)		
		@gvs = Giaovien.order :tengiaovien
        respond_to do |format|
          format.html
          format.csv { send_data @gvs.as_csv }
      end
	end	
	def new
		@giaovien = Giaovien.new
	end
	def show		
		@khoavien=@giaovien.khoavien
		@lopsinhviens=@giaovien.lopsinhviens				
	end
	def edit
		
	end
	def destroy
		@giaovien.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to giaoviens_path
		end
	def update

	      if @giaovien.update(x_params)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @giaovien
	      else
	       	render 'edit'
	      end
  	end
	def create
		@giaovien=Giaovien.new(x_params)
		if @giaovien.save
	      	flash[:success]= 'Tạo mới thành công .'
	        redirect_to @giaovien
	    else
	        render 'new'
	    end
    end	
	private
	def set_x
		@giaovien=Giaovien.find_by_id(params[:id])
		if @giaovien			
		else
			flash[:info]="Khong tim thay giao vien."
			redirect_to root_url
		end	
	end
	def x_params
	      params.require(:giaovien).permit(:magiaovien,:tengiaovien,:ngaysinh,:email,:khoavien_id)
	end
	
end
