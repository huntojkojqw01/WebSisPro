class BangDiemController < ApplicationController
  def index
		if(params)
			@diems=DkLop.joins("NATURAL JOIN SinhVien").where("masv like ? and diem != null ","%#{params[:fmasv]}%")
		else
			@diems=DkLop.where("diem != null ")
		end
	end
	def show
		
	end	
end
