class HockisController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user
	before_action :is_admin
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index		
		@hockis=Hocki.all
		@hockis.each do |hk|
			@hocki_id_lh=hk.id if hk.modangkilophoc==true
			@hocki_id_hp=hk.id if hk.modangkihocphan==true
		end			
	end
	def modangki
		@hockis=Hocki.all
		flag=nil
		if params[:hocki_id_hp]
			@hockis.each do |hk|				
				if hk.id==params[:hocki_id_hp].to_i
					hk.update(modangkihocphan: true)
					flag=hk.mahocki
				elsif hk.modangkihocphan
					hk.update(modangkihocphan: false)
				end
			end			
			if flag
				render plain: "科目登録できます。学期： #{flag}"
			else
				render plain: "これから科目登録できない"
			end
		else
			@hockis.each do |hk|				
				if hk.id==params[:hocki_id_lh].to_i
					hk.update(modangkilophoc: true)
					flag=hk.mahocki
				elsif hk.modangkilophoc
					hk.update(modangkilophoc: false)
				end
			end			
			if flag
				render plain: "クラス登録できます。学期： #{flag}"
			else
				render plain: "これからクラス登録できない"
			end				
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
		if @hocki.update(x_params)
	      	flash[:info]='更新しました'
	        redirect_to @hocki
	    else
	       	render 'edit'
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
	    params.require(:hocki).permit(:mahocki,:dinhmuchocphi,:bd,:kt,:modangkihocphan,:modangkilophoc)
	end
end
