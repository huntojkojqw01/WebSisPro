class HocphansController < ApplicationController
	def index
		@khoaviens=Khoavien.all
		if params[:mahocphan]!=''
			@hocphans=Hocphan.where("mahocphan like ?","%#{params[:mahocphan]}%")
		elsif params[:tenhocphan]!=''
			@hocphans=Hocphan.where("tenhocphan like ?","%#{params[:tenhocphan]}%")
		elsif params[:khoavien_id]!=''
			@hocphans=Khoavien.find_by(id:params[:khoavien_id]).hocphans
		else
			@hocphans=Hocphan.all
		end
	end
end
