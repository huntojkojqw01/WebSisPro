class LopHocController < ApplicationController
	def index
		if(params)
			@lophocs=LopHoc.where("malh like ? and phonghoc like ?","%#{params[:fmalh]}%","%#{params[:fphonghoc]}%")
		else
			@lophocs=LopHoc.all
		end
	end
	def show
		@lophoc=LopHoc.find_by_id(params[:id])
	end
end
