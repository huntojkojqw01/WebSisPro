class GiaoVienController < ApplicationController
	def index
		if(params)
			@giaoviens=GiaoVien.where("magv like ? and tengv like ?","%#{params[:fmagv]}%","%#{params[:ftengv]}%")
		else
			@giaoviens=GiaoVien.all
		end
	end
	def show
		@giaovien=GiaoVien.find_by_id(params[:id])
	end
end
