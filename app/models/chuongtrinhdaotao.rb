class Chuongtrinhdaotao < ApplicationRecord	
  belongs_to :lopsinhvien
  belongs_to :hocphan  
  validates :hocphan_id, uniqueness: {scope: :lopsinhvien_id}
  validates :hocki, presence: true, numericality: { only_integer: true,:greater_than_or_equal_to=>1,:less_than_or_equal_to=>10 }
end
