class Chuongtrinhdaotao < ApplicationRecord	
  belongs_to :lopsinhvien
  delegate :tenlopsinhvien,to: :lopsinhvien
  belongs_to :hocphan
  delegate :mahocphan,:tenhocphan,:tinchi,:tinchihocphi,:trongso,:tenkhoavien,to: :hocphan  
  validates :hocphan_id, uniqueness: {scope: :lopsinhvien_id}
  validates :hocphan_id, presence: true
  validates :lopsinhvien_id, presence: true
  validates :hocki, presence: true, numericality: { only_integer: true,:greater_than_or_equal_to=>1,:less_than_or_equal_to=>10 }
  default_scope {order(:hocki)}
end
