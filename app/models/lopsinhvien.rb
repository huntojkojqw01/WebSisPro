class Lopsinhvien < ApplicationRecord
  belongs_to :giaovien
  belongs_to :khoavien
  has_many :sinhviens
  has_many :chuongtrinhdaotaos
end
