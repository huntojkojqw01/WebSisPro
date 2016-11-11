# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Hocphan.destroy_all
Sinhvien.destroy_all
Lophoc.destroy_all
User.create!(name:"admin",password:"123456",password_confirmation:"123456",loai:"ad")
2.upto(20) do |i|
	User.create!(name:"sv#{i}",password:"123456",password_confirmation:"123456",loai:"sv")
	Sinhvien.create!(masv:"SinhVien #{i}",tensv:Faker::Name.name,ngaysinh:Faker::Date.between(23.years.ago,18.years.ago),email:Faker::Internet.email,user_id:i)
end


1.upto(20) do |i|
	Hocphan.create!(mahp:"HocPhan #{i}",tenhp:Faker::Name.name,tc:(Faker::Number.between(1,3)+1)*10,tchp:(Faker::Number.between(1,5)+1)*10,heso:Faker::Number.between(7,8),open:Faker::Boolean.boolean)
end
21.upto(40) do |i|
	User.create!(name:"gv#{i-20}",password:"123456",password_confirmation:"123456",loai:"gv")
	Giaovien.create!(magv:"GiaoVien #{i}",tengv:Faker::Name.name,ngaysinh:Faker::Date.between(23.years.ago,18.years.ago),email:Faker::Internet.email,user_id:i)
	Lophoc.create!(malp:"LopHoc #{i}",phonghoc:"D#{rand(10)-rand(500)}",hocphan_id:i-20,giaovien_id:i-20)
end
