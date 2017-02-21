class Hocki < ApplicationRecord
	has_many :dangkihocphans, dependent: :destroy	
	has_many :lophocs, dependent: :destroy
	has_many :dangkilophocs, through: :lophocs
	has_many :hocphans, through: :lophocs
	validate :hocki_validate
	validates :mahocki, presence: true, length: { maximum: 5 } , uniqueness: true
	validates :dinhmuchocphi, numericality: { only_integer: true,:greater_than_or_equal_to=>100 }
	default_scope {order(:mahocki)}
	def hocki_validate
		errors.add(:time,"始まる時点(#{bd}) >= 終わる時点(#{kt})、無効") if bd>=kt
		hockis=Hocki.where("mahocki!=?",mahocki)
		hockis.each do |hk|
			if hk.bd==bd
				errors.add(:time,"時間重複。学期： #{hk.mahocki}")
			else
				if hk.bd<bd 
					errors.add(:time,"時間重複。学期： #{hk.mahocki}") if hk.kt>=bd
				else
					errors.add(:time,"時間重複。学期： #{hk.mahocki}") if hk.bd<=kt
				end
			end
		end		
	end	
end
