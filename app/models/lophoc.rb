class Lophoc < ApplicationRecord
  belongs_to :giaovien
  belongs_to :hocphan
  belongs_to :hocki
  has_many :dangkilophocs, dependent: :destroy
  has_many :sinhviens ,through: :dangkilophocs
end
