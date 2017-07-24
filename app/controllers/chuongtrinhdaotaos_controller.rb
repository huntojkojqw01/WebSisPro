class ChuongtrinhdaotaosController < ApplicationController
	before_action :logged_in_user
	before_action :is_admin, only: [:new,:create,:destroy]
	before_action :set_x, only: [:destroy]
	def index
		@ctdts=Chuongtrinhdaotao.includes(:hocphan,:lopsinhvien)			
	end	
	def new
		@chuongtrinhdaotao = Chuongtrinhdaotao.new		
	end
	def show
		@lopsinhvien=Lopsinhvien.find_by_id(params[:id])				
		unless @lopsinhvien
			flash[:danger]= t 'shared.notfound'	
			redirect_to root_url
		else
			@ctdts=@lopsinhvien.chuongtrinhdaotaos.includes(hocphan: :khoavien)				
		end						
	end
	def edit		
	end
	def destroy
		if params[:ids]
			params[:ids].each do |ctdt_id|
				ctdt=Chuongtrinhdaotao.find_by_id(ctdt_id)
				if ctdt
					ctdt.destroy					
				end
			end			        
			respond_to do |f|
				f.json {render json: {destroy_success: 'success'}}				
			end
		else			
			@chuongtrinhdaotao.destroy			
			flash[:info]= t 'shared.deleted'
			redirect_to chuongtrinhdaotaos_path
		end		
	end
	def update	    
  end
	def create
		@chuongtrinhdaotao=Chuongtrinhdaotao.new(x_params)
		if @chuongtrinhdaotao.save
	    flash[:success]= t 'shared.added'
	    redirect_to chuongtrinhdaotaos_path
	  else
	  	flash.now[:danger]= t 'shared.notadd'
	    render 'new'
	  end
  end	
	private
	def set_x
		unless params[:ids] || @chuongtrinhdaotao=Chuongtrinhdaotao.find_by_id(params[:id])	
			flash[:danger]= t 'shared.notfound'	
			redirect_to root_url	
		end
	end
	def x_params
	    params.require(:chuongtrinhdaotao).permit(:lopsinhvien_id,:hocphan_id,:hocki)
	end
end
