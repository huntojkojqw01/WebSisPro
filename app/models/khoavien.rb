class Khoavien < ApplicationRecord
	require 'csv'
	has_many :hocphans, dependent: :destroy
	has_many :lophocs, through: :hocphans
	has_many :lopsinhviens, dependent: :destroy
	has_many :sinhviens, through: :lopsinhviens
	validates :tenkhoavien, :diadiem , presence: true, length: { maximum: 50 } , uniqueness: true
	default_scope {order(:tenkhoavien)}
	def self.import file
		dem=0
		CSV.foreach(file.path, {headers: true, col_sep: ','}).with_index do |row,i|
			dem=i+2
			kv_hash=row.to_hash.slice("tenkhoavien","sodienthoai","diadiem")
			return [false,dem,"Thiếu cột dữ liệu, cần có: tenkhoavien,sodienthoai,diadiem"] unless kv_hash.length==3
			kv=Khoavien.find_by_tenkhoavien(kv_hash["tenkhoavien"])
			if kv
				return [false,dem,kv.errors.full_messages.join(',')] unless kv.update(kv_hash)
			else
				new_kv=Khoavien.new(kv_hash)
				return [false,dem,new_kv.errors.full_messages.join(',')] unless new_kv.save
			end
		end
		return [true,dem,""]
	end
end
