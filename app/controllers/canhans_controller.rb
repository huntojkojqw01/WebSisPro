class CanhansController < ApplicationController
	before_action :set_sinhvien
	def chuongtrinhdaotao
		@chuongtrinhdaotaos=@sinhvien.chuongtrinhdaotaos
	end
	def dangkihoctap
		
	end
	def thoikhoabieu
		
	end
	def bangdiem
		@dangkilophocs=@sinhvien.dangkilophocs.order(:hocki_id)
	end
	def thongtin
		
	end
	def hocphi
		
	end
	private
	def set_sinhvien
		@sinhvien=current_user.sinhvien
	end
end
