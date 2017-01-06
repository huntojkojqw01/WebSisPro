module ApplicationHelper
	def full_title title=""
		return title=="" ? "SisHedspi" : title+" | WebSisPro"
	end
	def hello
		case current_user.loai
		when "ad"
			return "Xin chào admin"
		when "sv"
			return "Xin chào sinh viên"
		when "gv"
			return "Xin chào giáo viên"
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
					strTime="Thứ #{thu}:#{i+1-(thu-2)*12}-#{ketthuc-(thu-2)*12} "+strTime
					ketthuc=0					
				end
			end
			if i%12==0
				if ketthuc>i
					strTime="Thứ #{thu}:1-#{ketthuc-(thu-2)*12} "+strTime
					ketthuc=i
				end
				thu-=1
			end	
		end
		strTime="Thứ 2:1-#{ketthuc} "+strTime if ketthuc>0
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
		return [false , "Lớp không có địa điểm"] unless diadiem
		return [false , "Lớp học không có giáo viên"] unless giaovien
		lop=Lophoc.find_by(malophoc:lophoc.malophoc)
		if lop
			return [false,"Lớp đã có sinh viên đăng kí, không thể thay đổi một số thông tin"] if (lop.diadiem!=lophoc.diadiem||lop.thoigian!=lophoc.thoigian||lop.hocphan_id!=lophoc.hocphan_id||lop.hocki_id!=lophoc.hocki_id)&&lop.dangkilophocs.count>0		
			return [false,"Số sinh viên đăng kí đã max, không thể thu hẹp"] if lop.maxdangki>lophoc.maxdangki&&lop.dangkilophocs.count>lophoc.maxdangki
		end
		lophocs=Lophoc.where("hocki_id=? and diadiem=? and malophoc!=?",lophoc.hocki_id,diadiem,lophoc.malophoc)
		lophocs.each do |lh|
			return [false,"Phòng học #{diadiem} đã được sử dụng cho lớp #{lh.malophoc}."]	if lh.thoigian&lophoc.thoigian>0
		end
		if giaovien		
			lophocs=giaovien.lophocs.where("hocki_id=? and malophoc!=?",lophoc.hocki_id,lophoc.malophoc)
			lophocs.each do |lh|
				return [false,"Giáo viên #{giaovien.tengiaovien} bị trùng lịch dạy với lớp (#{lh.malophoc})."]	if lh.thoigian&lophoc.thoigian>0
			end
		end
		return [true,""]	
	end
    def dangkilophocOk(dangkilophoc)
		sinhvien=dangkilophoc.sinhvien
		return [false , "Sinh viên không tồn tại hoặc đã thôi học"] unless sinhvien && sinhvien.trangthai		
		lophoc=dangkilophoc.lophoc
		return [false , "Lớp học không tồn tại"] unless lophoc
		hocki=lophoc.hocki
		hocphan=lophoc.hocphan
		return [false , "Lớp không có học kì"] unless hocki
		return [false , "Lớp học không có học phần tồn tại"] unless hocphan
		return [false , "Sinh viên chưa đăng kí học phần #{hocphan.mahocphan}"] unless sinhvien.dangkihocphans.where("hocphan_id=? and hocki_id=?",hocphan.id,hocki.id).count>0
		return [false , "Không phải thời điểm đăng kí lóp học cho học kì này"] unless lophoc.hocki.modangkilophoc
		return [false , "Lớp học đã đầy"] unless lophoc.maxdangki>lophoc.dangkilophocs.count
		lophocs=sinhvien.lophocs.where("hocki_id=? and malophoc!=?",lophoc.hocki_id,lophoc.malophoc)
		lophocs.each do |lh|
			return [false,"Trùng thời khóa biểu với lớp học #{lh.malophoc}"] if lh.thoigian&lophoc.thoigian>0
			return [false,"Trùng học phần với lớp học đã đăng kí #{lh.malophoc}(#{lh.hocphan.mahocphan})"] if lh.hocphan==lophoc.hocphan
		end
		return [true,""]
	end
	def dangkihocphanOk(dangkihocphan)
		sinhvien=dangkihocphan.sinhvien
		return [false , "Sinh viên không tồn tại hoặc đã thôi học"] unless sinhvien && sinhvien.trangthai		
		hocphan=dangkihocphan.hocphan		
		hocki=dangkihocphan.hocki
		return [false , "Đăng kí không có học kì"] unless hocki
		return [false , "Đăng kí không có học phần tồn tại"] unless hocphan
		return [false , "Không phải thời điểm đăng kí học phần cho học kì này"] unless hocki.modangkihocphan
		return [true,""]
	end		
	def hockiOk(hocki)
		return [false,"Thời gian bắt đầu(#{hocki.bd}) >= thời gian kết thúc(#{hocki.kt}), không hợp lệ"] if hocki.bd>=hocki.kt
		hockis=Hocki.where("mahocki!=?",hocki.mahocki)
		hockis.each do |hk|
			if hk.bd==hocki.bd
				return [false,"Trùng thời gian bắt đầu với học kì #{hk.mahocki}"]
			else
				if hk.bd<hocki.bd 
					return [false,"Trùng thời gian với học kì #{hk.mahocki}"] if hk.kt>=hocki.bd
				else
					return [false,"Trùng thời gian với học kì #{hk.mahocki}"] if hk.bd<=hocki.kt
				end
			end
		end
		return [true,""]
	end	
	
	def tietHoc(time)
		g=[[405, 450], [455, 500], [510, 555], [560, 605], [615, 660], [665, 710], [750, 795], [800, 845], [855, 900], [910, 955], [960, 1005], [1010, 1055]]
		tmp=time.hour*60+time.min
			
		case time.wday
		when 0
			return [false,time.wday,24*60-tmp+405,1]
		when 6
			return [false,time.wday,48*60-tmp+405,1]
		when 5
			g.each.with_index do |t,i|
				if tmp < t[0]
					return [false,time.wday,t[0]-tmp,12*(time.wday-1)+i+1]
					
				else
					if tmp<= t[1]
						return [true,time.wday,t[1]-tmp,12*(time.wday-1)+i+1]
						
					else
						next
					end
				end
			end
			return [false,time.wday,72*60-tmp+405,1]			
		else
			g.each.with_index do |t,i|
				if tmp < t[0]
					return [false,time.wday,t[0]-tmp,12*(time.wday-1)+i+1]
					
				else
					if tmp<= t[1]
						return [true,time.wday,t[1]-tmp,12*(time.wday-1)+i+1]						
					else
						next
					end
				end
			end
			return [false,time.wday,24*60-tmp+405,12*(time.wday-1)+12+1]						
		end		
	end
	def soTietToThu(sotiet)
		x=sotiet/12
		x+=1 if sotiet%12!=0
		case x
		when 0
			"Chủ nhật"
		when 1,2,3,4,5,6
			"Thứ #{x+1}"
		else
		end
	end
	def soTietToTiet(sotiet)
		if sotiet%12==0
			return 12
		else
			return sotiet%12
		end
	end	
	def tinhGoc(trongtiet,waitcu,sotiet,tg)
		return [false,0,0,0] if tg==0		
		wait=waitcu
		i=1<<(60-sotiet)
		if trongtiet
			if i&tg>0				
				return [true,soTietToTiet(sotiet),soTietToThu(sotiet),wait]
			else
				i=(i>>1)
			end
		end		
		goc=i
		begin
			if i&tg > 0
				return [false,soTietToTiet(sotiet),soTietToThu(sotiet),wait]
			else
				i=(i>>1)				
				if sotiet%2==1
					wait+=50
				elsif sotiet==60
					wait+=3715
					sotiet=0
					i=(1<<59)	
				elsif sotiet%12==0
					wait+=835
				elsif sotiet%6==0
					wait+=85
				else
					wait+=55
				end				
				sotiet+=1										
			end
		end until goc==i
		return [false,0,0,0]
	end
	
	def testTiet(lophocs)			
		x=tietHoc(Time.now)
		wait=10080
		mess=""
		if lophocs
			lophocs.each do |lh|
				r=tinhGoc(x[0],x[2],x[3],lh.thoigian)
				if r[0]
					return "Hiện đang học tiết học #{r[1]}, môn #{lh.hocphan.mahocphan}, của ngày #{r[2]}, còn #{r[3]} phút."
				else
					if r[3]< wait
						mess="Chờ #{r[3]} phút nữa đến tiết học kế tiếp (tiết #{r[1]}, môn #{lh.hocphan.mahocphan}, của ngày #{r[2]})."
						wait=r[3]
					end
				end
			end
			return mess
		else
		end		
	end

end
