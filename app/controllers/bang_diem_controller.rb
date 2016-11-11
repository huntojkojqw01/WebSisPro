class BangDiemsController < ApplicationController
  def index
		if(params)
			@diems=Dklop.joins("NATURAL JOIN Sinhvien").where("masv like ? and diem != null ","%#{params[:fmasv]}%")
		else
			@diems=Dklop.where("diem != null ")
		end
	end
	def show

	end
end
