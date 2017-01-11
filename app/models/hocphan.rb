class Hocphan < ApplicationRecord
  belongs_to :khoavien
  has_many :chuongtrinhdaotaos, dependent: :destroy
  has_many :lophocs, dependent: :destroy
  has_many :dangkilophocs, through: :lophocs
  has_many :dangkihocphans, dependent: :destroy
  validates :tenhocphan, presence: true, length: { maximum: 50 }
  validates :mahocphan, presence: true, length: { maximum: 10 }, uniqueness: true
  validates :tinchihocphi, :tinchi, presence: true, numericality: { :greater_than_or_equal_to=>1, :less_than_or_equal_to=>6 }
  validates :trongso, presence: true, numericality: { :greater_than_or_equal_to=>0.1, :less_than_or_equal_to=>1.0 }
  default_scope {order(:mahocphan)}
  def self.as_csv
  		CSV.generate do |csv|
	      csv << column_names
	      all.each do |item|
	        csv << item.attributes.values_at(*column_names)
	      end
	    end
  	end
end
