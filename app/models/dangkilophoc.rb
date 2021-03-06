class Dangkilophoc < ApplicationRecord	
  require 'csv'
  belongs_to :sinhvien
  delegate :masinhvien,to: :sinhvien
  belongs_to :lophoc
  delegate :mahocki,:malophoc,:thoigian,:diadiem,:maxdangki,:mahocphan,:tenhocphan,:tinchi,:tinchihocphi,:trongso,to: :lophoc
  validates :sinhvien_id, presence: true  	
  validates :lophoc_id, uniqueness: {scope: :sinhvien_id},presence: true
  validate :dklh_validate ,on: :create
  validates :diemquatrinh,:diemthi, numericality: { :greater_than_or_equal_to=>0,:less_than_or_equal_to=>10 }, allow_nil: true
  validates :diemso, numericality: { :greater_than_or_equal_to=>0,:less_than_or_equal_to=>4.5 }, allow_nil: true
  validates :diemchu, format: { with: /\A[A-D,F]{1}+[+]{0,1}\z/}, allow_nil: true
  def dklh_validate
		sinhvien=Sinhvien.find_by_id(sinhvien_id)
		errors.add(:sinhvien_id , :finished) unless sinhvien && sinhvien.trangthai		
		lophoc=Lophoc.find_by_id(lophoc_id)
		if lophoc
			hocki=lophoc.hocki
			hocphan=lophoc.hocphan				
			errors.add(:lophoc_id, :notopen) unless hocki.modangkilophoc
			errors.add(:lophoc_id , :isfull) unless lophoc.maxdangki>lophoc.dangkilophocs.count
			lophocs=sinhvien.lophocs.where("hocki_id=? and malophoc!=?",lophoc.hocki_id,lophoc.malophoc)
			lophocs.each do |lh|
				errors.add(:lophoc_id, :duplicationtime) if lh.thoigian&lophoc.thoigian>0
				errors.add(:lophoc_id, :duplicationsubject) if lh.hocphan==lophoc.hocphan
			end
		end		
	end	
  def self.import(file)
    dem=0
    CSV.foreach(file.path, headers: true).with_index do |row,i|
    	dem=i+2
	    dklh_hash = row.to_hash.slice("masinhvien","malophoc","diemquatrinh","diemthi")      
	    return [false,dem,"Thiếu cột dữ liệu, cần có: masinhvien,malophoc,diemquatrinh,diemthi"] if dklh_hash.length!=4       
	    sinhvien=Sinhvien.find_by_masinhvien(dklh_hash["masinhvien"])        
	    return [false,dem,"Mã sinh viên không tồn tại"] unless sinhvien
	    lophoc=Lophoc.find_by_malophoc(dklh_hash["malophoc"])
	    return [false,dem,"Mã lớp học không tồn tại"] unless lophoc
	    dklhs = Dangkilophoc.where("sinhvien_id=? and lophoc_id=?",sinhvien.id,lophoc.id)        
	    trongso=lophoc.hocphan.trongso        	
	    dklh_hash.except!("masinhvien","malophoc") 
			if dklh_hash["diemquatrinh"]
	      if dklh_hash["diemthi"]
		      dklh_hash["diemso"],dklh_hash["diemchu"]=Dangkilophoc.tinhDiem(dklh_hash["diemquatrinh"],dklh_hash["diemthi"],trongso)
		    else
		      dklh_hash["diemquatrinh"]=dklh_hash["diemquatrinh"].to_f
		    end
		  else
		  	if dklh_hash["diemthi"]
		      dklh_hash["diemthi"]=dklh_hash["diemthi"].to_f		        	        	
		    end
	    end                   
	    if dklhs.count>0          
			  dklh=dklhs.first
			  return [false,dem,dklh.errors.full_messages.join(',')] unless dklh.update(dklh_hash)              
			else          
		    return [false,dem,"Đăng kí lớp học này không tồn tại, không thể cập nhật điểm số."]
		  end        
    end # end CSV.foreach
    return [true,dem,""]
  end # end self.im 
  def self.tinhDiem(diemquatrinh,diemthi,trongso)
  	diemquatrinh=diemquatrinh.to_f
  	diemthi=diemthi.to_f
  	trongso=trongso.to_f
		return [0,"F"] if diemquatrinh<3.0 || diemthi<3.0
		diem=((1-trongso)*diemquatrinh+trongso*diemthi)
		if diem>=9.45			
			return [4,"A+"]
		elsif diem>=8.45
			return [4,"A"]
		elsif diem>7.95 # tren sis thi tinh la >7.95 moi duoc B+
			return [3.5,"B+"]
		elsif diem>=6.95
			return [3,"B"]
		elsif diem>=6.45
			return [2.5,"C+"]
		elsif diem>=5.45
			return [2,"C"]
		elsif diem>=4.95
			return [1.5,"D+"]
		elsif diem>=3.95
			return [1,"D"]
		else
			return [0,"F"]
		end
	end  
end
