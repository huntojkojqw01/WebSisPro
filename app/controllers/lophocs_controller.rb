class LophocsController < ApplicationController
	def index
		@hockis=Hocki.order(mahocki: :asc)
		@khoaviens=Khoavien.all
		@selected=params
		if params[:malophoc]!=''
			@lophocs=Lophoc.where("malophoc like ?","%#{params[:malophoc]}%")
		elsif params[:mahocphan]!=''
			@lophocs=Lophoc.left_outer_joins(:hocphan).where("mahocphan like ?","%#{params[:mahocphan]}%")
		elsif params[:khoavien_id]
			@lophocs=Khoavien.find_by(id:params[:khoavien_id]).lophocs
		elsif params[:hocki_id]
			@lophocs=Hocki.find_by(id:params[:hocki_id]).lophocs
		else
			@lophocs=Lophoc.all
		end
		@results=[]
		@lophocs.each do |lh|
			hocphan=lh.hocphan
			khoavien=hocphan.khoavien
			@results<<{lophoc_id:lh.id,malophoc:lh.malophoc,mahocphan:hocphan.mahocphan,tenhocphan:hocphan.tenhocphan,trangthai:hocphan.modangki,maxdangki:lh.maxdangki,dadangki:lh.dangkilophocs.count,khoavien:khoavien.tenkhoavien}
		end
	end
	def show
		@lophoc=Lophoc.find_by_id(params[:id])		
		@sinhviens=@lophoc.sinhviens
		@results=[]
		@sinhviens.each do |sv|
			trangthaidangki=sv.dangkilophocs.find_by(lophoc_id:@lophoc.id).trangthaidangki
			@results<<{masinhvien:sv.masinhvien,tensinhvien:sv.tensinhvien,lopsinhvien:sv.lopsinhvien.tenlopsinhvien,trangthaidangki:trangthaidangki}
		end
	end
end
