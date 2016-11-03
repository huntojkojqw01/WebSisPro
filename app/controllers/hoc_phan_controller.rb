class HocPhanController < ApplicationController
	def index		
		if(params)
			@hocphans=HocPhan.where("mahp like ? and tenhp like ?","%#{params[:fmahp]}%","%#{params[:ftenhp]}%")
		else
			@hocphans=HocPhan.all
		end
	end
	def show
		@hocphan=HocPhan.find_by_id(params[:id])
	end
end
