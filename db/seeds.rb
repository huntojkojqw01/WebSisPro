# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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
nam=2010
1.upto(10) do |i|	
	Hocki.create!(mahocki:"#{nam}#{i%3+1}",dinhmuchocphi:i*20+100)
	nam+=1 if i%3==0
end
1.upto(5) do |i|
	khoa=Khoavien.create(tenkhoavien:"Khoa,Vien #{i}",sodienthoai:Faker::PhoneNumber.phone_number,diadiem:"toa nha D#{i}")
end
1.upto(30) do |i|
	tmp=Khoavien.count
	tmp=rand(tmp)+Khoavien.first.id	
	Hocphan.create!(mahocphan:"HocPhan #{i}",tenhocphan:Faker::Name.name,tinchi:(Faker::Number.between(1,3)+1)*10,tinchihocphi:(Faker::Number.between(1,5)+1)*10,trongso:Faker::Number.between(7,8),modangki:Faker::Boolean.boolean,khoavien_id:tmp)
end
1.upto(10) do |i|
	tmp=Khoavien.count
	tmp=rand(tmp)+Khoavien.first.id	
	Giaovien.create!(magiaovien:"Giaovien #{i}",tengiaovien:Faker::Name.name,ngaysinh:Faker::Date.between_except(60.year.ago, 24.year.from_now, Date.today),email:(Faker::Internet.email),khoavien_id:tmp)
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
	Sinhvien.create!(masinhvien:"SinhVien #{i}",tensinhvien:Faker::Name.name,ngaysinh:Faker::Date.between(23.years.ago,18.years.ago),email:Faker::Internet.email,trangthai:Faker::Boolean.boolean,lopsinhvien_id:tmp,user_id:user.id)
end
hocphans=Hocphan.all
hocphans.each.with_index do |hp,j|
	1.upto(10) do |i|
		tmp=Giaovien.count
		tmp=rand(tmp)+Giaovien.first.id
		tmp2=Hocki.count
		tmp2=rand(tmp2)+Hocki.first.id
		Lophoc.create(malophoc:"Lop hoc #{j*10+i}",thoigian:rand(60),diadiem:"D#{j*10+i}",maxdangki:40+rand(10),hocphan_id:hp.id,giaovien_id:tmp,hocki_id:tmp2)
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
		tmp=Sinhvien.count
		tmp=rand(tmp)+Sinhvien.first.id
		tmp2=Hocki.count
		tmp2=rand(tmp2)+Hocki.first.id
		tmp3=Lophoc.count
		tmp3=rand(tmp3)+Lophoc.first.id	
		Dangkilophoc.create(diemquatrinh:rand(10),diemthi:rand(10),hesohocphi:rand(3),trangthaidangki:"thanh cong",lophoc_id:tmp3,sinhvien_id:tmp,hocki_id:tmp2)
end
1.upto(20) do |i|
		tmp=Hocphan.count
		tmp=rand(tmp)+Hocphan.first.id
		tmp2=Lopsinhvien.count
		tmp2=rand(tmp2)+Lopsinhvien.first.id		
		Chuongtrinhdaotao.create(hocki:rand(10)+1,hocphan_id:tmp,lopsinhvien_id:tmp2)
end


