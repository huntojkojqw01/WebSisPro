class Dangkihocphan < ApplicationRecord
  	belongs_to :sinhvien
  	belongs_to :hocphan
  	belongs_to :hocki
  	validate :dkhp_validate
  	validates :hocphan_id, uniqueness: {scope: [:sinhvien_id,:hocki_id],message: "重複しました"}
  	def dkhp_validate  		
		sinhvien=Sinhvien.find_by_id(sinhvien_id)
		errors.add(:sinhvien,"その学生はいません。あるいは辞めた学生です。") unless sinhvien && sinhvien.trangthai		
		hocphan=Hocphan.find_by_id(hocphan_id)		
		hocki=Hocki.find_by_id(hocki_id)
		errors.add(:hocki, "正しい学期情報が必要") unless hocki
		errors.add(:hocphan, "正しい科目情報が必要") unless hocphan
		errors.add(:hocki, "今科目登録できない、管理者に連楽してください") unless hocki.modangkihocphan
	end
end
