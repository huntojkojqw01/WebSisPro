class Hocki < ApplicationRecord
	has_many :dangkihocphans	
	has_many :lophocs
	has_many :dangkilophocs, through: :lophocs
end
