class Lopsinhvien < ApplicationRecord
	require 'csv'
  	belongs_to :giaovien
  	belongs_to :khoavien
  	has_many :sinhviens, dependent: :destroy
  	has_many :chuongtrinhdaotaos, dependent: :destroy
    validates :tenlopsinhvien, presence: true, length: { maximum: 50 }, uniqueness: true
    validates :khoahoc, presence: true, numericality: { only_integer: true, :greater_than_or_equal_to=>50, :less_than_or_equal_to=>70 }
  	default_scope {order(:tenlopsinhvien)}
    def self.as_csv
  		CSV.generate do |csv|
	      csv << column_names
	      all.each do |item|
	        csv << item.attributes.values_at(*column_names)
	      end
	    end
  	end
end
