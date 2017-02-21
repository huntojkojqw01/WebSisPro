class ChuongtrinhdaotaosController < ApplicationController
	before_action :logged_in_user
	before_action :is_admin, only: [:new,:create,:destroy]
	before_action :set_x, only: [:destroy]
	def index
		@ctdts=Chuongtrinhdaotao.left_outer_joins(:hocphan,:lopsinhvien)
		.select("chuongtrinhdaotaos.*","tenlopsinhvien","mahocphan")
		.paginate(page: params[:page],per_page: 20)		
	end	
	def new
		@chuongtrinhdaotao = Chuongtrinhdaotao.new		
	end
	def show
		@lopsinhvien=Lopsinhvien.find_by_id(params[:id])				
		unless @lopsinhvien
			flash[:info]="見付からない"	
				redirect_to root_url
			else
			@ctdts=Chuongtrinhdaotao.joins(hocphan: :khoavien)
			.select("hocki","hocphans.*","tenkhoavien")
			.where(lopsinhvien_id: @lopsinhvien.id)
			.reorder(params[:sort_by])
			.paginate(page: params[:page],per_page: 20)
		end						
	end
	def edit		
	end
	def destroy
		@chuongtrinhdaotao.destroy
		flash[:info]= '削除しました'
		redirect_back fallback_location: root_path
	end
	def update	    
  	end
	def create
		@chuongtrinhdaotao=Chuongtrinhdaotao.new(x_params)
		if @chuongtrinhdaotao.save
	      	flash[:success]= '追加しました'
	        redirect_to chuongtrinhdaotaos_path
	    else
	        render 'new'
	    end
    end	
	private
	def set_x
		unless @chuongtrinhdaotao=Chuongtrinhdaotao.find_by_id(params[:id])	
			flash[:info]="見付からない"	
			redirect_to root_url	
		end
	end
	def x_params
	    params.require(:chuongtrinhdaotao).permit(:lopsinhvien_id,:hocphan_id,:hocki)
	end
end
