# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
User.create!(name:"admin",password:"123456",password_confirmation:"123456",loai:"admin")
User.create!(name:"sv1",password:"123456",password_confirmation:"123456",loai:"sv")
User.create!(name:"gv1",password:"123456",password_confirmation:"123456",loai:"gv")
HocPhan.destroy_all
SinhVien.destroy_all
LopHoc.destroy_all
1.upto(20) do |i|
	HocPhan.create!(mahp:"HocPhan #{i}",tenhp:Faker::Name.name,tc:(Faker::Number.between(1,3)+1)*10,tchp:(Faker::Number.between(1,5)+1)*10,heso:Faker::Number.between(7,8),open:Faker::Boolean.boolean)
	SinhVien.create!(masv:"SinhVien #{i}",tensv:Faker::Name.name,ngaysinh:Faker::Date.between(23.years.ago,18.years.ago),email:Faker::Internet.email,user_id:i)
	GiaoVien.create!(magv:"GiaoVien #{i}",tengv:Faker::Name.name,ngaysinh:Faker::Date.between(23.years.ago,18.years.ago),email:Faker::Internet.email,user_id:i)
	LopHoc.create!(malh:"LopHoc #{i}",phonghoc:"D#{rand(10)-rand(500)}",hocphan_id:i)
end


