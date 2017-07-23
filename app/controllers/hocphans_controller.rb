class HocphansController < ApplicationController
	before_action :logged_in_user, except: [:index]
	before_action :is_admin, except: [:index,:show]
	before_action :set_x, only: [:edit,:update,:destroy]
	def index		
		@hocphans=Hocphan.includes(:khoavien)
	end	
	def new
		@hocphan = Hocphan.new
	end
	def show		
		@hocphan=Hocphan.left_outer_joins(:khoavien).where("hocphans.id=?",params[:id])
				.select("hocphans.*","tenkhoavien").first			
	end
	def edit		
	end
	def destroy
		if params[:ids]
			params[:ids].each do |hocphan_id|
				hocphan=Hocphan.find_by_id(hocphan_id)
				if hocphan
					hocphan.destroy					
				end
			end			        
			respond_to do |f|
				f.json {render json: {destroy_success: 'success'}}				
			end
		else			
			@hocphan.destroy
			flash[:info]= '削除しました'
			redirect_to hocphans_path
		end		
	end
	def update
	    if @hocphan.update(x_params)
	      	flash[:info]='更新しました'
	        redirect_to @hocphan
	    else
	       	render 'edit'
	    end
  	end
	def create
		@hocphan=Hocphan.new(x_params)
		if @hocphan.save
	      	flash[:success]= '追加しました'
	        redirect_to @hocphan
	    else
	        render 'new'
	    end
    end    
  def import
    begin
	  	r=Hocphan.import(params[:file])    	
		  if r[0]
		    flash[:success]= "File is imported(#{r[1]-1} record)."	      
		  else
				flash[:danger]= "エラ➖ #{r[1]}: #{r[2]}."			
		  end
		rescue
		  flash[:danger]= "Invalid CSV file format."
		end
	  redirect_back fallback_location: hocphans_path
  end	
	private
	def set_x
		unless params[:ids] || @hocphan=Hocphan.find_by_id(params[:id])
			flash[:info]="見付からない"	
			redirect_to root_url	
		end		
	end
	def x_params
	    params.require(:hocphan).permit(:mahocphan,:tenhocphan,:tinchi,:tinchihocphi,:trongso,:modangki,:khoavien_id)
	end	
end
