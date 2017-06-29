class Giaovien < ApplicationRecord  
  belongs_to :khoavien
  delegate :tenkhoavien, to: :khoavien
  has_many :lopsinhviens, dependent: :nullify
  has_many :lophocs, dependent: :nullify
  validates :tengiaovien, presence: true, length: { maximum: 50 }
  validates :magiaovien, presence: true, length: { maximum: 10 }, uniqueness: true 
  validates :email,:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
  default_scope {order(:tengiaovien)}
  def self.as_csv
  		CSV.generate do |csv|
	      csv << column_names
	      all.each do |item|
	        csv << item.attributes.values_at(*column_names)
	      end
	    end
  end  
end
