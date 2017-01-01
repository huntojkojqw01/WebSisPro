class Chuongtrinhdaotao < ApplicationRecord
	
  belongs_to :lopsinhvien
  belongs_to :hocphan  
  validates :hocphan_id, uniqueness: {scope: :lopsinhvien_id}
end
