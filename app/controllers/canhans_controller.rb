class CanhansController < ApplicationController
	#before_action :set_sinhvien, unless: [:thoikhoabieu,:hocphi]
	def chuongtrinhdaotao
		@results=[]
		@chuongtrinhdaotaos=@sinhvien.chuongtrinhdaotaos
		@chuongtrinhdaotaos.each do |ctdt|
			hocphan=ctdt.hocphan
			khoavien=hocphan.khoavien
			if dangki=hocphan.dangkilophocs.where("sinhvien_id=#{@id}").last
				diemso=diemso(dangki.diemquatrinh,dangki.diemthi,hocphan.trongso)
				diemchu=diemchu(diemso)
			else
				diemso=diemchu=nil
			end
			@results<<{mahocphan:hocphan.mahocphan,tenhocphan:hocphan.tenhocphan,hocki:ctdt.hocki,tinchi:hocphan.tinchi,diemchu:diemchu,diemso:diemso,khoavien:khoavien.tenkhoavien}
		end
	end
	def dangkihoctap
		@hockis=Hocki.order(mahocki: :asc	)
		@results=[]
		if params[:masinhvien]!=''
			@dangkilophocs=Dangkilophoc.joins(:sinhvien).where("masinhvien like ?","%#{params[:masinhvien]}%")
		else
			@dangkilophocs=Dangkilophoc.all
		end
		@dangkilophocs.each do |dklh|
			sinhvien=dklh.sinhvien
			hocphan=dklh.lophoc.hocphan
			@results<<{masinhvien:sinhvien.masinhvien,tensinhvien:sinhvien.tensinhvien,ngaysinh:sinhvien.ngaysinh,malophoc:dklh.lophoc.malophoc,mahocphan:hocphan.mahocphan,tenhocphan:hocphan.tenhocphan}
		end
	end
	def thoikhoabieu
		
  		# Respond with JSON. This would respond with something like '{"id": 1, "name": "FooBar"}'
  		@users = Khoavien.all
   		
   end
  		#render 'thoikhoabieu'
	end
	def bangdiem
		@bangdiems=[]
		@dangkilophocs=Dangkilophoc.where("sinhvien_id=#{@id}")
		@dangkilophocs.each do |dklh|			
			lophoc=dklh.lophoc
			hocki=lophoc.hocki
			hocphan=lophoc.hocphan
			diemchu=diemchu(diemso(dklh.diemquatrinh,dklh.diemthi,hocphan.trongso))
			@bangdiems<<{mahocki:hocki.mahocki,mahocphan:hocphan.mahocphan,tenhocphan:hocphan.tenhocphan,tinchi:hocphan.tinchi,malophoc:lophoc.malophoc,diemquatrinh:dklh.diemquatrinh,diemthi:dklh.diemthi,diemchu:diemchu}
		end
	end
	def thongtin
		
	end
	def hocphi
		
	end
	private
	def set_sinhvien
		@sinhvien=current_user.sinhvien
		@id=@sinhvien.id
	end
	def diemso(diemquatrinh,diemthi,trongso)
		return 0 if diemquatrinh<3||diemthi<3
		diem=((10-trongso)*diemquatrinh+trongso*diemthi)/10.0
		if diem>=9.45			
			return 4.5
		elsif diem>=8.45
			return 4
		elsif diem>=7.95
			return 3.5
		elsif diem>=6.95
			return 3
		elsif diem>=6.45
			return 2.5
		elsif diem>=5.45
			return 2
		elsif diem>=4.95
			return 1.5
		elsif diem>=3.95
			return 1
		else
			return 0
		end
	end
	def diemchu(diemso)
		case diemso
		when 4.5
			return "A+"
		when 4
			return "A"
		when 3.5
			return "B+"
		when 3
			return "B"
		when 2.5
			return "C+"
		when 2
			return "C"
		when 1.5
			return "D+"
		when 1
			return "D"
		else
			return "F"	
		end			
	end
end
