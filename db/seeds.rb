# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
def tinhDiem(diemquatrinh,diemthi,trongso)
  		diemquatrinh=diemquatrinh.to_f
  		diemthi=diemthi.to_f
  		trongso=trongso.to_f
		return [0,"F"] if diemquatrinh<3.0 || diemthi<3.0
		diem=((1-trongso)*diemquatrinh+trongso*diemthi)
		if diem>=9.45			
			return [4,"A+"]
		elsif diem>=8.45
			return [4,"A"]
		elsif diem>7.95
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
def randomTime
	x=rand(12)+1
	"#{rand(5)+2},#{x},#{ x+rand(13-x)}"
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
if true
Chuongtrinhdaotao.destroy_all
Dangkihocphan.destroy_all
Dangkilophoc.destroy_all
Sinhvien.destroy_all
Lopsinhvien.destroy_all
Lophoc.destroy_all
Giaovien.destroy_all
Hocphan.destroy_all
Khoavien.destroy_all
Hocki.destroy_all
User.destroy_all

User.create!(name:"admin",password:"123456",password_confirmation:"123456",loai:"ad")
i=100
2013.upto(2017) do |nam|	
	Hocki.create!(mahocki:"#{nam}1",dinhmuchocphi:i+20,bd:Date.new(nam,8,15),kt:Date.new(nam,8,15)+5.months,modangkihocphan:true,modangkilophoc:true)
	Hocki.create!(mahocki:"#{nam}2",dinhmuchocphi:i+40,bd:Date.new(nam+1,2,1),kt:Date.new(nam+1,2,1)+5.months,modangkihocphan:true,modangkilophoc:true)
	Hocki.create!(mahocki:"#{nam}3",dinhmuchocphi:i+60,bd:Date.new(nam+1,7,10),kt:Date.new(nam+1,7,10)+1.months,modangkihocphan:true,modangkilophoc:true)
	i+=100	
end
@hk=Hocki.count
@ihk=Hocki.first.id
#1.upto(10) do |i|
#	Khoavien.create(tenkhoavien:"Khoa viện #{i}",sodienthoai:Faker::PhoneNumber.phone_number,diadiem:" C#{rand(10)}-#{rand(400)+101}")
#end
#ADD KHOA VIEN:		
		CSV.foreach("./db/khoavien.csv", {headers: true, col_sep: ','}).with_index do |row,i|
			kv_hash=row.to_hash.slice("tenkhoavien","sodienthoai","diadiem")
			next unless kv_hash.length==3
			new_kv=Khoavien.new(kv_hash)
			next unless new_kv.save			
		end	
#___________________________
@kv=Khoavien.count
@ikv=Khoavien.first.id
#1.upto(50) do |i|	
	#Hocphan.create(mahocphan:"HP#{i}",tenhocphan:"Học phần #{i}",tinchi:rand(3)+2,tinchihocphi:rand(5)+2,trongso:(rand(2)+7)*0.1,khoavien_id:rand(@kv)+@ikv)
#end
#ADD HOC PHAN
	CSV.foreach("./db/hocphan.csv", { headers: true, :col_sep => ',' }).with_index do |row,i|
        hp_hash = row.to_hash.slice("mahocphan","tenhocphan","trongso","tinchi","tinchihocphi","tenkhoavien")
        next if hp_hash.length!=6      
        khoavien=Khoavien.find_by_tenkhoavien(hp_hash["tenkhoavien"])
        next unless khoavien
        hp_hash["khoavien_id"]=khoavien.id
        hp_hash.except! "tenkhoavien"
        hocphan=Hocphan.find_by(mahocphan: hp_hash["mahocphan"])                
        if hocphan
          next unless hocphan.update(hp_hash)
        else                      
          new_hocphan=Hocphan.new(hp_hash)          
          next unless new_hocphan.save
        end # if hocphan                   
      end # end CSV.foreach
#____________________________
@hp=Hocphan.count
@ihp=Hocphan.first.id
1.upto(10) do |i|	
	Giaovien.create(magiaovien:"GV#{i}",tengiaovien:"Giáo viên #{i}",ngaysinh:Faker::Date.between(60.years.ago,22.years.ago),email:"gv#{i}@gmail.com",khoavien_id:rand(@kv)+@ikv)
end
Giaovien.create(magiaovien:"CVT",tengiaovien:"Cao Văn Thủ",ngaysinh:Faker::Date.between(60.years.ago,22.years.ago),email:"cvt@gmail.com",khoavien_id:rand(@kv)+@ikv)
@gv=Giaovien.count
@igv=Giaovien.first.id
1.upto(10) do |i|	
	Lopsinhvien.create(tenlopsinhvien:"Lớp sinh viên #{i}",khoahoc:55+rand(7),giaovien_id:rand(@gv)+@igv,khoavien_id:rand(@kv)+@ikv)
end
lsv=Lopsinhvien.create(tenlopsinhvien:"Việt Nhật K58",khoahoc:58,giaovien_id:rand(@gv)+@igv,khoavien_id:rand(@kv)+@ikv)
@lsv=Lopsinhvien.count
@ilsv=Lopsinhvien.first.id
1.upto(10) do |i|	
	user=User.create(name:"sv#{i}",password:"123456",password_confirmation:"123456",loai:"sv")
	Sinhvien.create(masinhvien:"SV#{i}",tensinhvien:"Sinh viên #{i}",ngaysinh:Faker::Date.between(30.years.ago,18.years.ago),email:"sv#{i}@gmail.com",trangthai:Faker::Boolean.boolean,lopsinhvien_id:rand(@lsv)+@ilsv,user_id:user.id)
end
@sv=Sinhvien.count
@isv=Sinhvien.first.id
hocphans=Hocphan.all
hocphans.each.with_index do |hp,j|
	1.upto(10) do |i|		
		Lophoc.create(malophoc:"LH#{j*10+i}",thoigian:convertTime(randomTime),diadiem:"D#{j*10+i}-#{rand(400)+100}",maxdangki:40+rand(10),hocphan_id:hp.id,giaovien_id:rand(@gv)+@igv,hocki_id:rand(@hk)+@ihk)
	end
end
#ADD LOPHOC
	CSV.foreach("./db/lophoc.csv", { headers: true, :col_sep => ';' }).with_index do |row,i|
     
      lh_hash = row.to_hash.slice("malophoc","maxdangki","thoigian","diadiem","magiaovien","mahocphan","mahocki")
       next if lh_hash.length!=7       
      lh = Lophoc.find_by(malophoc: lh_hash["malophoc"])
      hocphan=Hocphan.find_by(mahocphan: lh_hash["mahocphan"])        
        next if hocphan==nil
      hocki=Hocki.find_by(mahocki: lh_hash["mahocki"])
        next if hocki==nil
      giaovien=Giaovien.find_by(magiaovien: lh_hash["magiaovien"])
        next if giaovien==nil          
              
      lh_hash.except!("magiaovien","mahocphan","mahocki")          
      lh_hash["giaovien_id"]=giaovien.id
      lh_hash["hocphan_id"]=hocphan.id
      lh_hash["hocki_id"]=hocki.id          
      lh_hash["thoigian"]=Lophoc.convertTime(lh_hash["thoigian"])          
      if lh
        next unless lh.update(lh_hash)
      else                      
        new_lh=Lophoc.new(lh_hash)
        next unless new_lh.save       
      end # end if lh           
    end # end CSV.foreach
#_______________________________
@lh=Lophoc.count
@ilh=Lophoc.first.id
#1.upto(100) do |i|			
#		Dangkihocphan.create(hocphan_id:rand(@hp)+@ihp,sinhvien_id:rand(@sv)+@isv,hocki_id:rand(@hk)+@ihk)
#end

#1.upto(500) do |i|	
#		lh=Lophoc.find(rand(@lh)+@ilh)		
#		diemquatrinh=rand(10)
#		diemthi=rand(10)
#		trongso=lh.hocphan.trongso
#		x=tinhDiem(diemquatrinh,diemthi,trongso)		
#		Dangkilophoc.create(diemquatrinh:diemquatrinh,diemthi:diemthi,diemso:x[0],diemchu:x[1],hesohocphi:rand(3)+1,lophoc_id:lh.id,sinhvien_id:rand(@sv)+@isv)
#end
#ADD DKLH
	CSV.foreach("./db/dklh.csv",{headers: true, col_sep: ','}).with_index do |row,i|
		dem=i+2
		hash=row.to_hash.slice("masinhvien","malophoc")
		next if hash.length!=2
		sv=Sinhvien.find_by_masinhvien(hash["masinhvien"])
		next unless sv
		hash["sinhvien_id"]=sv.id
		hash.except! "masinhvien"
		lh=Lophoc.find_by_malophoc(hash["malophoc"])
		next unless lh
		hash["lophoc_id"]=lh.id
		hp=lh.hocphan
		Dangkihocphan.create!(sinhvien_id: sv.id,hocphan_id: hp.id,hocki_id: lh.hocki_id)
		hash.except! "malophoc"
		hash["hesohocphi"]=Dangkilophoc.joins(:lophoc).where("sinhvien_id=? and hocphan_id=?",sv.id,lh.hocphan_id).count+1 if lh
		dklh=Dangkilophoc.new(hash)
		if !dklh.save			
			#puts "Row: #{dem}=> #{dklh.errors.full_messages.join(',')}"
			next
		end
	end
#________________________________
1.upto(10) do |i|		
		tmp=rand(@hp)+@ihp
		tmp2=rand(@lsv)+@ilsv		
		if Chuongtrinhdaotao.where("hocphan_id=? and lopsinhvien_id=?",tmp,tmp2).count==0		
			Chuongtrinhdaotao.create(hocki:rand(10)+1,hocphan_id:tmp,lopsinhvien_id:tmp2)			
		else
		end
end
end

if true
	#init CTDT
	#dem=0
	CSV.foreach("./db/ctdt.csv",{headers: true, col_sep: ','}).with_index do |row,i|
		#dem=i+2
		hash=row.to_hash.slice("hocki","tenlopsinhvien","mahocphan")
		next if hash.length!=3
		lsv=Lopsinhvien.find_by_tenlopsinhvien(hash["tenlopsinhvien"])
		next unless lsv
		hash["lopsinhvien_id"]=lsv.id
		hash.except! "tenlopsinhvien"
		hp=Hocphan.find_by_mahocphan(hash["mahocphan"])
		next unless hp
		hash["hocphan_id"]=hp.id
		hash.except! "mahocphan"
		ctdt=Chuongtrinhdaotao.new(hash)
		if !ctdt.save
			#puts "Row: #{dem}=> #{ctdt.errors.full_messages.join(',')}"
			break
		end
	end
	#puts dem
end
if false
	#init DKLH
	dem=0
	CSV.foreach("./db/dklh.csv",{headers: true, col_sep: ','}).with_index do |row,i|
		dem=i+2
		hash=row.to_hash.slice("masinhvien","malophoc")
		next if hash.length!=2
		sv=Sinhvien.find_by_masinhvien(hash["masinhvien"])
		next unless sv
		hash["sinhvien_id"]=sv.id
		hash.except! "masinhvien"
		lh=Lophoc.find_by_malophoc(hash["malophoc"])
		next unless lh
		hash["lophoc_id"]=lh.id
		hash.except! "malophoc"
		hash["hesohocphi"]=Dangkilophoc.joins(:lophoc).where("sinhvien_id=? and hocphan_id=?",sv.id,lh.hocphan_id).count+1 if lh
		dklh=Dangkilophoc.new(hash)
		if !dklh.save			
			puts "Row: #{dem}=> #{dklh.errors.full_messages.join(',')}"
			break
		end
	end
	puts dem
end

