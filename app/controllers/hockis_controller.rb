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
			if @hocki && @hocki != opening_hocki
				opening_hocki.update(modangkilophoc: false)
				@hocki.update(modangkilophoc: true)
				render plain: "クラス登録できます。学期： #{@hocki.mahocki}"
			end
		else
			if @hocki.update(x_params)
		      	flash[:info]='更新しました'
		        redirect_to @hocki
		    else
		       	render 'edit'
		    end
		end	    
  	end
	def create
		@hocki=Hocki.new(x_params)
		if @hocki.save
		    flash[:success]= '追加しました'
		   	redirect_to @hocki
		else
		    render 'new'
		end		  
    end	
	private
	def set_x
		unless @hocki=Hocki.find_by_id(params[:id])	
			flash[:info]="見付からない"	
			redirect_to root_url	
		end	
	end
	def x_params
	    params.require(:hocki).permit(:mahocki,:dinhmuchocphi,:bd,:kt,:modangkilophoc)
	end
end
