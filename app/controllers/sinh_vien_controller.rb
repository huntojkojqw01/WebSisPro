class SinhVienController < ApplicationController
	def index
		if(params)
			@sinhviens=Sinhvien.where("masv like ? and tensv like ?","%#{params[:fmasv]}%","%#{params[:ftensv]}%")
		else
			@sinhviens=Sinhvien.all
		end
	end
	def show
		@sinhvien=Sinhvien.find_by_id(params[:id])
	end
end
