class Hocphan < ApplicationRecord
  belongs_to :khoavien
  has_many :lophocs
  has_many :dangkilophocs, through: :lophocs
end
