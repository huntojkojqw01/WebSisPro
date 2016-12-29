class Hocphan < ApplicationRecord
  belongs_to :khoavien
  has_many :lophocs, dependent: :destroy
  has_many :dangkilophocs, through: :lophocs
end
