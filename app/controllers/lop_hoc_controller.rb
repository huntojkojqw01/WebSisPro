class LopHocController < ApplicationController
	def index
		if(params)
			@lophocs=Lophoc.where("malh like ? and phonghoc like ?","%#{params[:fmalh]}%","%#{params[:fphonghoc]}%")
		else
			@lophocs=Lophoc.all
		end
	end
	def show
		@lophoc=Lophoc.find_by_id(params[:id])
	end
end
