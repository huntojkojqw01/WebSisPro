class Khoavien < ApplicationRecord
	has_many :hocphans, dependent: :destroy
	has_many :lophocs, through: :hocphans
	has_many :lopsinhviens, dependent: :destroy
	has_many :sinhviens, through: :lopsinhviens
end
