class Dangkilophoc < ApplicationRecord	
  belongs_to :sinhvien
  belongs_to :lophoc 
  validates :diemquatrinh,:diemthi, numericality: { :greater_than_or_equal_to=>0,:less_than_or_equal_to=>10 }, allow_nil: true
  validates :diemso, numericality: { :greater_than_or_equal_to=>0,:less_than_or_equal_to=>4.5 }, allow_nil: true
  validates :diemchu, format: { with: /\A[A-D]+\z/ }, allow_nil: true
  def self.import(file)
      dem=0
      CSV.foreach(file.path, headers: true) do |row|
        dklh_hash = row.to_hash.except("id")        
        sinhvien=Sinhvien.find_by(masinhvien: dklh_hash["masinhvien"])
        lophoc=Lophoc.find_by(malophoc: dklh_hash["malophoc"])              
        if sinhvien && lophoc
        	dklh_hash["sinhvien_id"]=sinhvien.id
          	dklh_hash["lophoc_id"]=lophoc.id
        	trongso=lophoc.hocphan.trongso
        	dklh = Dangkilophoc.where("sinhvien_id=? and lophoc_id=?",sinhvien.id,lophoc.id)
          	dklh_hash.except!("masinhvien","malophoc")          
          if dklh_hash["diemquatrinh"] || dklh_hash["diemthi"]
          	dklh_hash["diemquatrinh"]=dklh_hash["diemquatrinh"].to_f
          	dklh_hash["diemthi"]=dklh_hash["diemthi"].to_f
          	dklh_hash["diemso"]=Dangkilophoc.diemso(dklh_hash["diemquatrinh"],dklh_hash["diemthi"],trongso)
          	dklh_hash["diemchu"]=Dangkilophoc.diemchu(dklh_hash["diemso"])
          	p "dau"
          end                   
          if dklh.count == 1            
            dklh.first.update_attributes(dklh_hash)
          else                      
            Dangkilophoc.create!(dklh_hash)          
          end # end if !product.nil?
          dem+=1
        end
      end # end CSV.foreach
      return dem
  end # end self.im 
  def self.diemso(diemquatrinh,diemthi,trongso)
		return 0 if diemquatrinh<3.0 || diemthi<3.0
		diem=((1-trongso)*diemquatrinh+trongso*diemthi)
		if diem>=9.45			
			return 4.5
		elsif diem>=8.45
			return 4
		elsif diem>=7.95
			return 3.5
		elsif diem>=6.95
			return 3
		elsif diem>=6.45
			return 2.5
		elsif diem>=5.45
			return 2
		elsif diem>=4.95
			return 1.5
		elsif diem>=3.95
			return 1
		else
			return 0
		end
end
def self.diemchu(diemso)
		case diemso
		when 4.5
			return "A+"
		when 4
			return "A"
		when 3.5
			return "B+"
		when 3
			return "B"
		when 2.5
			return "C+"
		when 2
			return "C"
		when 1.5
			return "D+"
		when 1
			return "D"
		else
			return "F"	
		end			
end
end
