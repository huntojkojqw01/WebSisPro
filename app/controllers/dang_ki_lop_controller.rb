class DangKiLopController < ApplicationController
	def index
		if(params)
			@dklops=DkLop.joins("NATURAL JOIN SinhVien").where("masv like ?","%#{params[:fmasv]}%")
		else
			@dklops=DkLop.all
		end
	end
	def show
		@dklop=DkLop.find_by_id(params[:id])
	end	
end
