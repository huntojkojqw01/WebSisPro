class Dangkilophoc < ApplicationRecord	
  	require 'csv'
  	belongs_to :sinhvien
  	belongs_to :lophoc
  	validate :dklh_validate ,on: :create	
  	validates :lophoc_id, uniqueness: {scope: :sinhvien_id,message: "Lớp học này đã được đăng kí rồi!"}
  	validates :diemquatrinh,:diemthi, numericality: { :greater_than_or_equal_to=>0,:less_than_or_equal_to=>10 ,:message => " :điểm số theo thang 10 nhé (0.0->10.0)" }, allow_nil: true
  	validates :diemso, numericality: { :greater_than_or_equal_to=>0,:less_than_or_equal_to=>4.5, :message => " :điểm số không hợp lệ "  }, allow_nil: true
  	validates :diemchu, format: { with: /\A[A-D,F]{1}+[+]{0,1}\z/,:message => " :điểm chữ không hợp lệ "  }, allow_nil: true
  	def dklh_validate
		sinhvien=Sinhvien.find_by_id(sinhvien_id)
		errors.add(:sinhvien , "Sinh viên đã thôi học") unless sinhvien && sinhvien.trangthai		
		lophoc=Lophoc.find_by_id(lophoc_id)
		if lophoc
			hocki=lophoc.hocki
			hocphan=lophoc.hocphan
			errors.add(:lophoc, "Lớp không có học kì") unless hocki
			errors.add(:lophoc, "Lớp học không có học phần tồn tại") unless hocphan
			errors.add(:hocphan, "Sinh viên chưa đăng kí học phần #{hocphan.mahocphan}") unless sinhvien.dangkihocphans.where("hocphan_id=? and hocki_id=?",hocphan.id,hocki.id).count>0
			errors.add(:hocki, "Không phải thời điểm đăng kí lớp học cho học kì này") unless lophoc.hocki.modangkilophoc
			errors.add(:lophoc , "Lớp học đã đầy") unless lophoc.maxdangki>lophoc.dangkilophocs.count
			lophocs=sinhvien.lophocs.where("hocki_id=? and malophoc!=?",lophoc.hocki_id,lophoc.malophoc)
			lophocs.each do |lh|
				errors.add(:thoigian,"Trùng thời khóa biểu với lớp học #{lh.malophoc}") if lh.thoigian&lophoc.thoigian>0
				errors.add(:hocphan,"Trùng học phần với lớp học đã đăng kí #{lh.malophoc}(#{lh.hocphan.mahocphan})") if lh.hocphan==lophoc.hocphan
			end
		else
			errors.add(:lophoc , "Lớp học không tồn tại")
		end		
	end	
  	def self.import(file)
    	dem=1
    	CSV.foreach(file.path, headers: true) do |row|
	        dklh_hash = row.to_hash.slice("masinhvien","malophoc","diemquatrinh","diemthi")      
	        return [false,dem,"Thiếu cột dữ liệu, cần có: masinhvien,malophoc,diemquatrinh,diemthi"] if dklh_hash.length!=4       
	        dklh = Dangkilophoc.where("")
	        sinhvien=Sinhvien.find_by(masinhvien: dklh_hash["masinhvien"])        
	        return [false,dem,"Mã sinh viên không tồn tại"] if sinhvien==nil
	        lophoc=Lophoc.find_by(malophoc: dklh_hash["malophoc"])
	        return [false,dem,"Mã lớp học không tồn tại"] if lophoc==nil
	        dklh = Dangkilophoc.where("sinhvien_id=? and lophoc_id=?",sinhvien.id,lophoc.id)        
	        trongso=lophoc.hocphan.trongso        	
	        dklh_hash.except!("masinhvien","malophoc") 
			if dklh_hash["diemquatrinh"]
	          	if dklh_hash["diemthi"]
		          	x=Dangkilophoc.tinhDiem(dklh_hash["diemquatrinh"],dklh_hash["diemthi"],trongso)
		          	dklh_hash["diemso"]=x[0]
		          	dklh_hash["diemchu"]=x[1]
		        else
		        	dklh_hash["diemquatrinh"]=dklh_hash["diemquatrinh"].to_f
		        end
		    else
		    	if dklh_hash["diemthi"]
		          	dklh_hash["diemthi"]=dklh_hash["diemthi"].to_f
		        else	        	
		        end
	        end                   
	        if dklh.count>0          
			    begin         
			        dklh.first.update(dklh_hash)              
			    rescue
			        return [false,dem,"Lỗi thông tin khi cập nhật "]
			    end
	        else          
		        return [false,dem,"Đăng kí lớp học này không tồn tại, không thể cập nhật điểm số."]
		    end # end if !product.nil?
	        dem+=1        
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
		elsif diem>=7.95
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
  
	def self.dangkilophocOk(dangkilophoc)
		sinhvien=dangkilophoc.sinhvien
		return [false , "Sinh vien da thoi hoc nen khong the dang ki"] unless sinhvien.trangthai		
		lophoc=dangkilophoc.lophoc
		hocki=lophoc.hocki
		hocphan=lophoc.hocphan
		return [false , "Sinh vien chua dang ki hoc phan #{hocphan.mahocphan}"] unless sinhvien.dangkihocphans.where("hocphan_id=? and hocki_id=?",hocphan.id,hocki.id).count>0
		return [false , "Khong phai thoi diem dang ki lop cho hoc ki nay"] unless lophoc.hocki.modangkilophoc
		return [false , "Lop hoc da day nen khong the dang ki"] unless lophoc.maxdangki>lophoc.dangkilophocs.count
		lophocs=sinhvien.lophocs.where("hocki_id=? and malophoc!=?",lophoc.hocki_id,lophoc.malophoc)
		lophocs.each do |lh|
			return [false,"Trung thoi khoa bieu voi lop hoc #{lh.malophoc}"] if lh.thoigian&lophoc.thoigian>0
			return [false,"Trung hoc phan da dang ki voi lop hoc #{lh.malophoc}(#{lh.hocphan.mahocphan})"] if lh.hocphan==lophoc.hocphan
		end
		return [true,""]
	end
end
