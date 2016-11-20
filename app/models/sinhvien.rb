class Sinhvien < ApplicationRecord
  belongs_to :user
  belongs_to :lopsinhvien  
  has_many :chuongtrinhdaotaos, through: :lopsinhvien
  has_many :dangkilophocs
end
