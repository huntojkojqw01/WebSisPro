class HockisController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user
	before_action :is_admin
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index
		@selected=params
		x=Hocki.find_by(modangkihocphan: true)		
		if @selected[:hocki_id_hp]
			x.update(modangkihocphan: false) if x
			x=Hocki.find_by_id(@selected[:hocki_id_hp])
			x.update(modangkihocphan: true) if x			
		else
			@selected[:hocki_id_hp]=x.id if x
		end
		x=Hocki.find_by(modangkilophoc: true)		
		if @selected[:hocki_id_lh]
			x.update(modangkilophoc: false) if x
			x=Hocki.find_by_id(@selected[:hocki_id_lh])
			x.update(modangkilophoc: true) if x			
		else
			@selected[:hocki_id_lh]=x.id if x
		end
		@hockis=Hocki.order(:mahocki)			
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
		par=x_params
		hocki=Hocki.new(par)
		r=hockiOk(hocki)
		if r.first
	      if @hocki.update(par)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @hocki
	      else
	       	render 'edit'
	      end
	    else
	    	flash[:danger]=r.last
	    	redirect_to(:back)
	    end
  	end
	def create
		@hocki=Hocki.new(x_params)
		r=hockiOk(@hocki)
		if r.first
			if @hocki.save
		      	flash[:success]= 'Tạo mới thành công .'
		        redirect_to @hocki
		    else
		        render 'new'
		    end
		else
	    	flash[:danger]=r.last
	    	redirect_to(:back)
	    end   
    end	
	private
	def set_x
		@hocki=Hocki.find_by_id(params[:id])
		if @hocki			
		else
			flash[:info]="Khong tim thay hoc ki."
			redirect_to root_url
		end	
	end
	def x_params
	      params.require(:hocki).permit(:mahocki,:dinhmuchocphi,:bd,:kt,:modangkihocphan,:modangkilophoc)
	end
end
