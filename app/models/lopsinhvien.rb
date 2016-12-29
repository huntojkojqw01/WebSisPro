class Lopsinhvien < ApplicationRecord
	require 'csv'
  	belongs_to :giaovien
  	belongs_to :khoavien
  	has_many :sinhviens, dependent: :destroy
  	has_many :chuongtrinhdaotaos, dependent: :destroy
  	def self.as_csv
  		CSV.generate do |csv|
	      csv << column_names
	      all.each do |item|
	        csv << item.attributes.values_at(*column_names)
	      end
	    end
  	end
end
