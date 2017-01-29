class GiaoviensController < ApplicationController
	before_action :logged_in_user
	before_action :is_admin
	before_action :set_x, only: [:edit,:update]
	def index
		@selected=params.permit(:tengiaovien,:khoavien_id)		
		@khoaviens=Khoavien.all		
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			@giaoviens=Giaovien.joins(:khoavien)
			.where("khoavien_id = ? and tengiaovien like ?",@selected[:khoavien_id],"%#{@selected[:tengiaovien]}%").select("giaoviens.*","khoaviens.tenkhoavien").paginate(page: params[:page],:per_page=>10)
		else
			@giaoviens=Giaovien.joins(:khoavien)
			.where("tengiaovien like ?","%#{@selected[:tengiaovien]}%").select("giaoviens.*","khoaviens.tenkhoavien").paginate(page: params[:page],:per_page=>10)
		end		
		@gvs = Giaovien.all
        respond_to do |format|
            format.html
            format.csv { send_data @gvs.as_csv }
      end
	end	
	def new
		@giaovien = Giaovien.new
	end
	def show		
		@giaovien=Giaovien.joins(:khoavien).where("giaoviens.id=?",params[:id]).select("giaoviens.*","tenkhoavien").first			
	end
	def edit
		
	end
	def destroy
		
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
		unless @giaovien=Giaovien.find_by_id(params[:id])	
			flash[:info]="Không tìm thấy dữ liệu"	
			redirect_to root_url
		end
	end
	def x_params
	    params.require(:giaovien).permit(:magiaovien,:tengiaovien,:ngaysinh,:email,:khoavien_id)
	end
	
end
