class SinhviensController < ApplicationController
	def index
		@selected=params
		@khoaviens=Khoavien.select("id,tenkhoavien")		
		@lopsinhviens=Lopsinhvien.select("id,tenlopsinhvien,khoavien_id")
		@sinhviens=Sinhvien.joins("inner join lopsinhviens on sinhviens.lopsinhvien_id=lopsinhviens.id").select("sinhviens.*,tenlopsinhvien,khoavien_id")
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			@lopsinhviens=@lopsinhviens.where("khoavien_id=#{@selected[:khoavien_id]}")
			@sinhviens=@sinhviens.where("khoavien_id=#{@selected[:khoavien_id]}")
			if @selected[:lopsinhvien_id]&&@selected[:lopsinhvien_id]!=""
				@sinhviens=@sinhviens.where("lopsinhvien_id=#{@selected[:lopsinhvien_id]}")
			else
			end
		else			
		end
		@sinhviens=@sinhviens.where("tensinhvien like ? and masinhvien like ?","%#{params[:tensinhvien]}%","%#{params[:masinhvien]}%")	
	end
	def show
		@sinhvien=Sinhvien.find_by_id(params[:id])
		@lopsinhvien=@sinhvien.lopsinhvien		
		@bangdiems=Dangkilophoc.where("sinhvien_id=#{@sinhvien.id}").joins("inner join lophocs on lophoc_id=lophocs.id inner join hocphans on hocphan_id=hocphans.id inner join hockis on hocki_id=hockis.id").select("*")
		
		@selected=params
		@hockis=Hocki.order(mahocki: :asc)
		if @selected[:hocki_id]&&@selected[:hocki_id]!=""
			@dinhmuchocphi=Hocki.find_by_id(params[:hocki_id]).dinhmuchocphi		
			@tongtienphaidong=0
			@dangkilophocs=Dangkilophoc.joins("inner join lophocs on lophoc_id=lophocs.id inner join hocphans on hocphan_id=hocphans.id inner join hockis on hocki_id=hockis.id and lophocs.hocki_id=#{@selected[:hocki_id]} and sinhvien_id=#{@sinhvien.id}").select("*")
		else			
		end		
	end	
end
