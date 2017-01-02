class Sinhvien < ApplicationRecord
	require 'csv'
  	belongs_to :user
  	belongs_to :lopsinhvien  
  	has_many :chuongtrinhdaotaos, through: :lopsinhvien
  	has_many :dangkilophocs, dependent: :destroy
  	has_many :lophocs, through: :dangkilophocs
  	has_many :dangkihocphans, dependent: :destroy
  	validates :tensinhvien, presence: true, length: { maximum: 50 }
  	validates :masinhvien, presence: true, length: { maximum: 10 }, uniqueness: true  	
  	validates :email,:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
  	def self.import(file)
	    CSV.foreach(file.path, headers: true) do |row|

	      svien_hash = row.to_hash.except("id")
	      sv = Sinhvien.where(masinhvien: svien_hash["masinhvien"])
	      if lopsinhvien=Lopsinhvien.find_by(tenlopsinhvien: svien_hash["tenlopsinhvien"])
	      	svien_hash.except!("tenlopsinhvien")
	      	svien_hash["lopsinhvien_id"]=lopsinhvien.id
		      if sv.count == 1
		      	
		        sv.first.update_attributes(svien_hash)
		      else		      	      		
			    user=User.create!(name:svien_hash["masinhvien"],password:"123456",password_confirmation:"123456",loai:"sv")	      	
			    svien_hash["trangthai"]=true
			    
			    svien_hash["user_id"]=user.id
			    Sinhvien.create!(svien_hash)			    
		      end # end if !product.nil?
	      end
	    end # end CSV.foreach
	end # end self.im
	def self.as_csv
  	CSV.generate do |csv|
	      csv << column_names
	      all.each do |item|
	        csv << item.attributes.values_at(*column_names)
	      end
	    end
  	end
end
