class Lophoc < ApplicationRecord
  belongs_to :giaovien
  belongs_to :hocphan
  belongs_to :hocki
  has_many :dangkilophocs, dependent: :destroy
  has_many :sinhviens ,through: :dangkilophocs
  def self.as_csv
  	CSV.generate do |csv|
	      csv << column_names
	      all.each do |item|
	        csv << item.attributes.values_at(*column_names)
	      end
	    end
  end
end
