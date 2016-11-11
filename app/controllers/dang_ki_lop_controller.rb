class DangKiLopController < ApplicationController
	def index
		if(params)
			@dklops=Dklop.joins("NATURAL JOIN Sinhvien").where("masv like ?","%#{params[:fmasv]}%")
		else
			@dklops=Dklop.all
		end
	end
	def show
		@dklop=Dklop.find_by_id(params[:id])
	end
end
