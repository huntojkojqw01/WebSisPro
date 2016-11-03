class SinhVienController < ApplicationController
	def index
		if(params)
			@sinhviens=SinhVien.where("masv like ? and tensv like ?","%#{params[:fmasv]}%","%#{params[:ftensv]}%")
		else
			@sinhviens=SinhVien.all
		end
	end
	def show
		@sinhvien=SinhVien.find_by_id(params[:id])
	end
end
