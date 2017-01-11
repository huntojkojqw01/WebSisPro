class Dangkihocphan < ApplicationRecord
  belongs_to :sinhvien
  belongs_to :hocphan
  belongs_to :hocki
  validates :hocphan_id, uniqueness: {scope: [:sinhvien_id,:hocki_id]}
end
