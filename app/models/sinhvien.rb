class Sinhvien < ApplicationRecord
	require 'csv'
  	belongs_to :user
  	belongs_to :lopsinhvien  
  	has_many :chuongtrinhdaotaos, through: :lopsinhvien
  	has_many :dangkilophocs, dependent: :destroy
  	has_many :lophocs, through: :dangkilophocs
  	has_many :dangkihocphans, dependent: :destroy
  	has_many :hocphans, through: :dangkihocphans
  	validates :tensinhvien, presence: true, length: { maximum: 50 }
  	validates :masinhvien, presence: true, length: { maximum: 10 }, uniqueness: true  	
  	validates :email,:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
  	default_scope {order(:tensinhvien)}
  	def self.import(file)
  		dem=1
	    CSV.foreach(file.path, headers: true) do |row|
	    	sv_hash = row.to_hash.slice("masinhvien","tensinhvien","ngaysinh","email","tenlopsinhvien")
	    	return [false,dem,"Thiếu cột dữ liệu, cần có: masinhvien,tensinhvien,ngaysinh,email,tenlopsinhvien"] if sv_hash.length!=5
	    	
	    	sv = Sinhvien.find_by(masinhvien: sv_hash["masinhvien"])
	    	lopsinhvien=Lopsinhvien.find_by(tenlopsinhvien: sv_hash["tenlopsinhvien"])
	    	if lopsinhvien
	    		sv_hash["lopsinhvien_id"]=lopsinhvien.id
	    		sv_hash.delete("tenlopsinhvien")	    		
		    	if sv
		    		begin	      	
		    			sv.update_attributes(sv_hash)		    			
		    		rescue
		    			return [false,dem,"Lỗi thông tin khi cập nhật"]
		    		end
		    	else
		    		begin		      	      		
					    user=User.create!(name:sv_hash["masinhvien"],password:"123456",password_confirmation:"123456",loai:"sv")	      	
					    sv_hash["trangthai"]=true			    
					    sv_hash["user_id"]=user.id
					    x=Sinhvien.new(sv_hash)
					    if x.save					    	
					    else
					    	return [false,dem,x.errors.full_messages]
					    end
				    rescue
				    	return [false,dem,"Lỗi thông tin khi tạo mới"]
				    end			    
		      	end # end if !product.nil?		    	
			else
				return [false,dem,"Tên lớp sinh viên không tồn tại"]
	    	end
	    	dem+=1
	    end # end CSV.foreach
	    return [true,dem,""]
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
