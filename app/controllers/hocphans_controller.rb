class HocphansController < ApplicationController
	def index		
		@selected=params
		@khoaviens=Khoavien.all
		@hocphans=Hocphan.joins("inner join khoaviens on hocphans.khoavien_id=khoaviens.id").select("hocphans.id,mahocphan,tenhocphan,tinchi,tinchihocphi,trongso,modangki,tenkhoavien")
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			@hocphans=@hocphans.where("khoavien_id=#{params[:khoavien_id]}")
		else			
		end
		@hocphans=@hocphans.where("mahocphan like ? and tenhocphan like ?","%#{params[:mahocphan]}%","%#{params[:tenhocphan]}%")
	end
	def show
		@hocphan=Hocphan.find_by_id(params[:id])		
	end
end
