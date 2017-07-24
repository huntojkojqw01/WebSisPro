class HockisController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user
	before_action :is_admin
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index		
		@hockis=Hocki.all
		@hockis.each do |hk|
			@hocki_id_lh=hk.id if hk.modangkilophoc==true			
		end			
	end	
	def new
		@hocki = Hocki.new
	end
	def show			
	end
	def edit		
	end
	def destroy		
	end
	def update
		if params[:modangki]			
			opening_hocki=Hocki.find_by(modangkilophoc: true)
			opening_hocki.update(modangkilophoc: false) if opening_hocki			
			if @hocki				
				@hocki.update(modangkilophoc: true)
				render plain: t('.registerable')+@hocki.mahocki
			else
				render plain: t('.stopregister')	
			end
		else			
			if @hocki.update(x_params)
		    flash[:info]= t 'shared.updated'
		    redirect_to @hocki
		  else
		  	flash.now[:danger]= t 'shared.notupdate'
		    render 'edit'
		  end
		end	    
  	end
	def create		
		@hocki=Hocki.new(x_params)
		if @hocki.save
		  flash[:success]= t 'shared.added'
		  redirect_to @hocki
		else
			flash.now[:danger]= t 'shared.notadd'
		  render 'new'
		end		  
  end	
	private
	def set_x		
		unless (@hocki=Hocki.find_by_id(params[:id]))	|| params[:modangki]
			flash[:danger]= t 'shared.notfound'
			redirect_to root_url	
		end	
	end
	def x_params		
	  params.require(:hocki).permit(:mahocki,:dinhmuchocphi,:bd,:kt,:modangkilophoc)
	end
end
