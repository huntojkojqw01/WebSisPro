# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def diemso(diemquatrinh,diemthi,trongso)
		return 0 if diemquatrinh<3.0||diemthi<3.0
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
def diemchu(diemso)
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
2013.upto(2016) do |nam|	
	Hocki.create!(mahocki:"#{nam}1",dinhmuchocphi:i+20,bd:Date.new(nam,8,1),kt:Date.new(nam,8,1)+5.months)
	Hocki.create!(mahocki:"#{nam}2",dinhmuchocphi:i+40,bd:Date.new(nam+1,2,1),kt:Date.new(nam+1,2,1)+5.months)
	Hocki.create!(mahocki:"#{nam}3",dinhmuchocphi:i+60,bd:Date.new(nam+1,7,1),kt:Date.new(nam+1,7,1)+1.months)
	i+=100	
end
1.upto(10) do |i|
	khoa=Khoavien.create(tenkhoavien:"Khoa,Vien #{i}",sodienthoai:Faker::PhoneNumber.phone_number,diadiem:"toa nha D#{i}")
end
1.upto(30) do |i|
	tmp=Khoavien.count
	tmp=rand(tmp)+Khoavien.first.id	
	Hocphan.create!(mahocphan:"HP#{i}",tenhocphan:Faker::Name.name,tinchi:rand(3)+2,tinchihocphi:rand(5)+2,trongso:(rand(2)+7)*0.1,khoavien_id:tmp)
end
1.upto(10) do |i|
	tmp=Khoavien.count
	tmp=rand(tmp)+Khoavien.first.id	
	Giaovien.create!(magiaovien:"GV#{i}",tengiaovien:Faker::Name.name,ngaysinh:Faker::Date.between_except(60.year.ago, 24.year.from_now, Date.today),email:(Faker::Internet.email),khoavien_id:tmp)
end
1.upto(10) do |i|
	tmp=Khoavien.count
	tmp=rand(tmp)+Khoavien.first.id
	tmp2=Giaovien.count
	tmp2=rand(tmp2)+Giaovien.first.id
	Lopsinhvien.create!(tenlopsinhvien:"Lop sinh vien #{i}",khoahoc:55+rand(7),giaovien_id:tmp2,khoavien_id:tmp)
end
1.upto(30) do |i|
	tmp=Lopsinhvien.count
	tmp=rand(tmp)+Lopsinhvien.first.id
	user=User.create!(name:"sv#{i}",password:"123456",password_confirmation:"123456",loai:"sv")
	Sinhvien.create!(masinhvien:"SV#{i}",tensinhvien:Faker::Name.name,ngaysinh:Faker::Date.between(23.years.ago,18.years.ago),email:Faker::Internet.email,trangthai:Faker::Boolean.boolean,lopsinhvien_id:tmp,user_id:user.id)
end
hocphans=Hocphan.all
hocphans.each.with_index do |hp,j|
	1.upto(10) do |i|
		tmp=Giaovien.count
		tmp=rand(tmp)+Giaovien.first.id
		tmp2=Hocki.count
		tmp2=rand(tmp2)+Hocki.first.id
		Lophoc.create(malophoc:"LH#{j*10+i}",thoigian:convertTime(randomTime),diadiem:"D#{j*10+i}",maxdangki:40+rand(10),hocphan_id:hp.id,giaovien_id:tmp,hocki_id:tmp2)
	end
end
1.upto(10) do |i|
		tmp=Sinhvien.count
		tmp=rand(tmp)+Sinhvien.first.id
		tmp2=Hocki.count
		tmp2=rand(tmp2)+Hocki.first.id
		tmp3=Hocphan.count
		tmp3=rand(tmp3)+Hocphan.first.id	
		Dangkihocphan.create(hocphan_id:tmp3,sinhvien_id:tmp,hocki_id:tmp2)
end
1.upto(30) do |i|
		sinhvien=Sinhvien.offset(rand(Sinhvien.count)).first			
		lophoc=Lophoc.offset(rand(Lophoc.count)).first		
		diemquatrinh=rand(10)
		diemthi=rand(10)
		trongso=lophoc.hocphan.trongso
		diemso=diemso(diemquatrinh,diemthi,trongso)
		diemchu=diemchu(diemso)
		Dangkilophoc.create(diemquatrinh:diemquatrinh,diemthi:diemthi,diemso:diemso,diemchu:diemchu,hesohocphi:rand(3)+1,lophoc_id:lophoc.id,sinhvien_id:sinhvien.id)
end
1.upto(50) do |i|		
		tmp=Hocphan.count
		tmp=rand(tmp)+Hocphan.first.id
		tmp2=Lopsinhvien.count
		tmp2=rand(tmp2)+Lopsinhvien.first.id
		if Chuongtrinhdaotao.where("hocphan_id=? and lopsinhvien_id=?",tmp,tmp2).count==0		
			Chuongtrinhdaotao.create(hocki:rand(10)+1,hocphan_id:tmp,lopsinhvien_id:tmp2)			
		else
		end
end


