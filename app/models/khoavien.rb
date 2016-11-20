class Khoavien < ApplicationRecord
	has_many :hocphans
	has_many :lophocs, through: :hocphans
	has_many :lopsinhviens
	has_many :sinhviens, through: :lopsinhviens
end
