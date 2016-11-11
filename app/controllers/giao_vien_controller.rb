class GiaoVienController < ApplicationController
	def index
		if(params)
			@giaoviens=Giaovien.where("magv like ? and tengv like ?","%#{params[:fmagv]}%","%#{params[:ftengv]}%")
		else
			@giaoviens=Giaovien.all
		end
	end
	def show
		@giaovien=Giaovien.find_by_id(params[:id])
	end
end
