class Hocphan < ApplicationRecord
  belongs_to :khoavien
  has_many :lophocs, dependent: :destroy
  has_many :dangkilophocs, through: :lophocs
  has_many :dangkihocphans, dependent: :destroy
  def self.as_csv
  		CSV.generate do |csv|
	      csv << column_names
	      all.each do |item|
	        csv << item.attributes.values_at(*column_names)
	      end
	    end
  	end
end
