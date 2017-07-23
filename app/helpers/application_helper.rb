module ApplicationHelper
	def full_title title=""
		default=t("h.application.title")
		return title=="" ? default : title+" | "+default
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
					strTime="日 #{thu}:#{i+1-(thu-2)*12}-#{ketthuc-(thu-2)*12} "+strTime
					ketthuc=0					
				end
			end
			if i%12==0
				if ketthuc>i
					strTime="日 #{thu}:1-#{ketthuc-(thu-2)*12} "+strTime
					ketthuc=i
				end
				thu-=1
			end	
		end
		strTime="日 2:1-#{ketthuc} "+strTime if ketthuc>0
		return strTime
	end	
	def make_tkb(ds_lop)
    lichhoc=[]                
    ds_lop.each do |lop|
      60.times do |i|
        if (lop.thoigian&(1<<(59-i)))!=0
          lichhoc[i]=lop
        end
      end# 60.times            
    end#ds.each
    return lichhoc                  
  end # to_tkb      	
	def tietHoc(time)
		g=[[405, 450], [455, 500], [510, 555], [560, 605], [615, 660], [665, 710], [750, 795], [800, 845], [855, 900], [905, 950], [960, 1005], [1010, 1055]]
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
			"日曜日"
		when 1,2,3,4,5,6
			"日 #{x+1}"
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
				sotiet+=1
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
					return "今勉強しています。コマ： #{r[1]}、科目： #{lh.hocphan.mahocphan}, 日： #{r[2]}、あと #{r[3]/60} 時 #{r[3]%60} 分"
				else
					if r[3]< wait
						mess="待っています。あと #{r[3]/60} 時 #{r[3]%60} 分。次は (こま： #{r[1]}、科目： #{lh.hocphan.mahocphan}、日： #{r[2]})."
						wait=r[3]
					end
				end
			end
			return mess
		else
		end		
	end	
end
