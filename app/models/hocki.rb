class Hocki < ApplicationRecord
	has_many :dangkihocphans, dependent: :destroy	
	has_many :lophocs, dependent: :destroy
	has_many :dangkilophocs, through: :lophocs
	has_many :hocphans, through: :lophocs
	validates :mahocki, presence: true, length: { maximum: 5 } , uniqueness: true
	validates :dinhmuchocphi, numericality: { only_integer: true,:greater_than_or_equal_to=>100 }
	default_scope {order(:mahocki)}
end
