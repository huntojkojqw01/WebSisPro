class Hocki < ApplicationRecord
	has_many :dangkihocphans, dependent: :destroy	
	has_many :lophocs, dependent: :destroy
	has_many :dangkilophocs, through: :lophocs
end
