class Dangkihocphan < ApplicationRecord
  	belongs_to :sinhvien
  	belongs_to :hocphan
  	belongs_to :hocki
  	validate :dkhp_validate
  	validates :hocphan_id, uniqueness: {scope: [:sinhvien_id,:hocki_id],message: "Học phần đã được đăng kí rồi"}
  	def dkhp_validate  		
		sinhvien=Sinhvien.find_by_id(sinhvien_id)
		errors.add(:sinhvien,"Sinh viên không tồn tại hoặc đã thôi học") unless sinhvien && sinhvien.trangthai		
		hocphan=Hocphan.find_by_id(hocphan_id)		
		hocki=Hocki.find_by_id(hocki_id)
		errors.add(:hocki, "Đăng kí không có học kì") unless hocki
		errors.add(:hocphan, "Đăng kí không có học phần tồn tại") unless hocphan
		errors.add(:hocki, "Không phải thời điểm đăng kí học phần cho học kì này") unless hocki.modangkihocphan
	end
end
