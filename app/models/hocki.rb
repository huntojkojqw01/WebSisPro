class Hocki < ApplicationRecord		
	has_many :lophocs, dependent: :destroy
	has_many :dangkilophocs, through: :lophocs
	has_many :hocphans, through: :lophocs
	validates :bd,:kt, presence: true
	validate :hocki_validate
	validates :mahocki, presence: true, length: { maximum: 5 } , uniqueness: true, format: { with: /\A[0-9]+\z/ }
	validates :dinhmuchocphi, numericality: { only_integer: true,:greater_than_or_equal_to=>100 }
	default_scope {order(:mahocki)}
	def hocki_validate		
		errors.add(:bd,:bdgreaterthankt) if bd>=kt
		hockis=Hocki.where("mahocki!=?",mahocki)
		hockis.each do |hk|
			if bd.between? hk.bd, hk.kt
				errors.add(:bd,:duplicationsemestertime)			
			end
			if kt.between? hk.bd, hk.kt
				errors.add(:kt,:duplicationsemestertime)			
			end
		end		
	end	
end
