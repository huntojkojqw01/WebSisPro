class LopsinhviensController < ApplicationController
	def index
		@khoaviens=Khoavien.all
		@lopsinhviens=Lopsinhvien.where("tenlopsinhvien like ?","params[:tenlopsinhvien]")
		if params[:masinhvien]!=''
			@sinhviens=Sinhvien.where("masinhvien like ?","%#{params[:masinhvien]}%")
		elsif params[:tensinhvien]!=''
			@sinhviens=Sinhvien.where("tensinhvien like ?","%#{params[:tensinhvien]}%")
		elsif params[:khoavien_id]
			@sinhviens=Sinhvien.left_outer_joins(:lopsinhvien).where("khoavien_id=#{params[:khoavien_id]}")
		else
			@sinhviens=Sinhvien.all
		end
		@results=[]
		@sinhviens.each do |sv|
			@results<<{masinhvien:sv.masinhvien,tensinhvien:sv.tensinhvien,ngaysinh:sv.ngaysinh,tenlopsinhvien:sv.lopsinhvien.tenlopsinhvien}
		end
	end
	def show
		@lopsinhvien=Lopsinhvien.find_by_id(params[:id])
		@khoavien=@lopsinhvien.khoavien
		@giaovien=@lopsinhvien.giaovien
		@sinhviens=@lopsinhvien.sinhviens
	end
end
