class HocPhanController < ApplicationController
	def index
		if(params)
			@hocphans=Hocphan.where("mahp like ? and tenhp like ?","%#{params[:fmahp]}%","%#{params[:ftenhp]}%")
		else
			@hocphans=Hocphan.all
		end
	end
	def show
		@hocphan=Hocphan.find_by_id(params[:id])
	end
end
