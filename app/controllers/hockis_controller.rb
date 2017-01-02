class HockisController < ApplicationController
	include ApplicationHelper
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index
		@selected=params
		if @selected[:hocki_id_hp]
			Hocki.all.each do |hk|				
				if hk.id==@selected[:hocki_id_hp].to_i					
					hk.update(modangkihocphan: true)
				else
					hk.update(modangkihocphan: false)
				end
			end
		end
		if @selected[:hocki_id_lh]
			Hocki.all.each do |hk|
				if hk.id==@selected[:hocki_id_lh].to_i
					hk.update(modangkilophoc: true)
				else
					hk.update(modangkilophoc: false)
				end
			end
		end
		@hockis=Hocki.order(mahocki: :asc).paginate(page: params[:page],:per_page=>10)			
	end	
	def new
		@hocki = Hocki.new
	end
	def show		
						
	end
	def edit
		
	end
	def destroy
		@hocki.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to hockis_path
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
