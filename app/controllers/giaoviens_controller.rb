class GiaoviensController < ApplicationController
	before_action :logged_in_user
	before_action :is_admin
	before_action :set_x, only: [:edit,:update,:destroy]
	def index		
		@giaoviens=Giaovien.includes(:khoavien)		
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
		if params[:ids]
			params[:ids].each do |giaovien_id|
				giaovien=Giaovien.find_by_id(giaovien_id)
				if giaovien
					giaovien.destroy					
				end
			end			        
			respond_to do |f|
				f.json {render json: {destroy_success: 'success'}}				
			end
		else			
			@giaovien.destroy			
			flash[:info]= t 'shared.deleted'
			redirect_to giaoviens_path
		end
	end
	def update
	  if @giaovien.update(x_params)
	    flash[:info]= t 'shared.updated'
	    redirect_to @giaovien
	  else
	  	flash.now[:danger]= t 'shared.notupdate'
	   	render 'edit'
	  end
  end
	def create
		@giaovien=Giaovien.new(x_params)
		if @giaovien.save
	    flash[:success]= t 'shared.added'
	    redirect_to @giaovien
	  else
	  	flash.now[:danger]= t 'shared.notadd'
	    render 'new'
	  end
  end    
	private
	def set_x
		unless params[:ids] || @giaovien=Giaovien.find_by_id(params[:id])	
			flash[:info]= t 'shared.notfound'
			redirect_to root_url
		end
	end
	def x_params
	    params.require(:giaovien).permit(:magiaovien,:tengiaovien,:ngaysinh,:email,:khoavien_id)
	end
	
end
