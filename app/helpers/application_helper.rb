module ApplicationHelper
	def full_title title=""
		return title=="" ? "Rails by ProTeam" : title+" | WebSisPro"
	end
	def hello
		case current_user.loai
		when "ad"
			return "Xin chao admin"
		when "sv"
			return "Xin chao sinh vien"
		when "gv"
			return "Xin chao giao vien"
		else
		end
	end
	def toIntTime(strTime)
		
		x=strTime.split(",").collect {|k| k.to_i}
		return 0 if x.count!=3||x[0]<2||x[0]>6||x[1]<1||x[1]>12||x[2]<1||x[2]>12
		tmp=1
		x[1].upto(x[2]-1) do |m|
			tmp=(tmp<<1)+1			
		end
		return tmp<<(48-12*(x[0]-2)+12-x[2])
	end
	def convertTime(thoigian)
		t=0
		strTimes=thoigian.split('-')
		strTimes.each do |time|
			t|=toIntTime(time)
		end
		return t
	end
	def getCurTkb(sinhvien,hocki)
		t=0
		sinhvien.lophocs.where("hocki_id=?",hocki.id).each do |lh|
			t|=lh.thoigian
		end
		return t
	end
	def getCurTkbByDiadiem(diadiem,hocki)
		t=0
		Lophoc.where("hocki_id=? and diadiem=?",hocki.id,diadiem).each do |lh|
			t|=lh.thoigian
		end
		return t
	end
	def checkTkb(oldTkb,newTkb)
		#p "TKB cu: #{toStrTime(oldTkb)}"
		#p toStrBitTime(oldTkb)
		#p "TKB them #{toStrTime(newTkb)}"
		#p toStrBitTime(newTkb)
		return (oldTkb&newTkb)==0 ? true : false 
	end
	def toStrBitTime(intTime)		
		strTime=''
		bitCheck=1		
		60.downto(1) do |i|
			strTime=" "+strTime if i%12==0
			t=(intTime&bitCheck)
			t= t>0 ? 1 : 0
			strTime="#{t}#{strTime}"
					
			bitCheck=bitCheck<<1
		end
		return strTime
	end
	def toStrTime(intTime)
		strTime=''
		bitCheck=1
		thu=7		
		ketthuc=0
		60.downto(1) do |i|			
			if intTime&(1<<(60-i)) >0
				ketthuc=i if ketthuc==0				
			else
				if ketthuc>0																	
					strTime="Thu #{thu}:#{i+1-(thu-2)*12}-#{ketthuc-(thu-2)*12} "+strTime
					ketthuc=0					
				end
			end
			if i%12==0
				if ketthuc>i
					strTime="Thu #{thu}:1-#{ketthuc-(thu-2)*12} "+strTime
					ketthuc=i
				end
				thu-=1
			end	
		end
		strTime="Thu 2:1-#{ketthuc} "+strTime if ketthuc>0
		return strTime
	end	
	def to_tkb(ds_lop)
                array=[]                
                ds_lop.each do |lop|
                        60.times do |i|
                            if (lop.thoigian&(1<<(59-i)))!=0
                              array[i]=lop
                            end
                        end# 60.times            
                        
                end#ds.each
                return array                  
          end # to_tkb   
    def lophocOk(lophoc)
		diadiem=lophoc.diadiem
		giaovien=lophoc.giaovien
		lop=Lophoc.find_by(malophoc:lophoc.malophoc)
		if lop
			return [false,"Lop hoc da co sinh vien dang ki, khong the thay doi dia diem , thoi gian"] if (lop.diadiem!=lophoc.diadiem||lop.thoigian!=lophoc.thoigian)&&lop.dangkilophocs.count>0		
			return [false,"So sinh vien dang ki da max, khong the thu hep"] if lop.maxdangki>lophoc.maxdangki&&lop.dangkilophocs.count>lophoc.maxdangki
		end
		lophocs=Lophoc.where("hocki_id=? and diadiem=? and malophoc!=?",lophoc.hocki_id,diadiem,lophoc.malophoc)
		lophocs.each do |lh|
			return [false,"Phong hoc #{diadiem} da duoc su dung cho lop #{lh.malophoc}."]	if lh.thoigian&lophoc.thoigian>0
		end		
		lophocs=giaovien.lophocs.where("hocki_id=? and malophoc!=?",lophoc.hocki_id,lophoc.malophoc)
		lophocs.each do |lh|
			return [false,"Giao vien #{giaovien.tengiaovien} bi trung lich day voi lop(#{lh.malophoc})."]	if lh.thoigian&lophoc.thoigian>0
		end	
		return [true,""]	
	end
    def dangkilophocOk(dangkilophoc)
		sinhvien=dangkilophoc.sinhvien
		return [false , "Sinh vien da thoi hoc nen khong the dang ki"] unless sinhvien.trangthai		
		lophoc=dangkilophoc.lophoc
		hocphan=lophoc.hocphan
		return [false , "Sinh vien chua dang ki hoc phan #{hocphan.mahocphan}"] unless sinhvien.dangkihocphans.find_by(hocphan_id:hocphan.id)
		return [false , "Khong phai thoi diem dang ki lop cho hoc ki nay"] unless lophoc.hocki.modangkilophoc
		return [false , "Lop hoc da day nen khong the dang ki"] unless lophoc.maxdangki>lophoc.dangkilophocs.count
		lophocs=sinhvien.lophocs.where("hocki_id=?",lophoc.hocki_id)
		lophocs.each do |lh|
			return [false,"Trung thoi khoa bieu voi lop hoc #{lh.malophoc}"] if lh.thoigian&lophoc.thoigian>0
			return [false,"Trung hoc phan da dang ki voi lop hoc #{lh.malophoc}(#{lh.hocphan.mahocphan})"] if lh.hocphan==lophoc.hocphan
		end
		return [true,""]
	end
	def dangkihocphanOk(dangkihocphan)
		sinhvien=dangkihocphan.sinhvien
		return [false , "Sinh vien da thoi hoc nen khong the dang ki"] unless sinhvien.trangthai		
		hocphan=dangkihocphan.hocphan		
		hocki=dangkihocphan.hocki
		return [false , "Khong phai thoi diem dang ki hoc phan cho hoc ki nay"] unless hocki.modangkihocphan
		return [true,""]
	end		
	def hockiOk(hocki)
		return [false,"Thoi gian bat dau(#{hocki.bd}) >= thoi gian ket thuc(#{hocki.kt}), khong hop le"] if hocki.bd>=hocki.kt
		hockis=Hocki.where("mahocki!=?",hocki.mahocki)
		hockis.each do |hk|
			if hk.bd<=hocki.bd
				return [false,"Trung thoi gian voi hoc ki #{hk.mahocki}"] if hk.kt>hocki.bd
			else
				return [false,"Trung thoi gian voi hoc ki #{hk.mahocki}"] if hk.bd<=hocki.kt
			end
		end
		return [true,""]
	end	
end
