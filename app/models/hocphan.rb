class Hocphan < ApplicationRecord
  require 'csv'
  belongs_to :khoavien
  delegate :tenkhoavien,to: :khoavien
  has_many :chuongtrinhdaotaos, dependent: :destroy
  has_many :lophocs, dependent: :destroy
  has_many :dangkilophocs, through: :lophocs  
  validates :tenhocphan, presence: true, length: { maximum: 60 }
  validates :mahocphan, presence: true, length: { maximum: 10 }, uniqueness: true
  validates :tinchi, presence: true, numericality: { :greater_than_or_equal_to=>0, :less_than_or_equal_to=>10 }
  validates :tinchihocphi, presence: true, numericality: { :greater_than_or_equal_to=>1, :less_than_or_equal_to=>30 }
  validates :trongso, presence: true, numericality: { :greater_than_or_equal_to=>0.1, :less_than_or_equal_to=>1.0 }
  default_scope {order(:mahocphan)}
  def self.as_csv
  		CSV.generate do |csv|
	      csv << column_names
	      all.each do |item|
	        csv << item.attributes.values_at(*column_names)
	      end
	    end
  end
  def self.import file    
    dem=0 
    CSV.foreach(file.path, { headers: true, :col_sep => ',' }).with_index do |row,i|
      dem=i+2
      hp_hash = row.to_hash.slice("mahocphan","tenhocphan","trongso","tinchi","tinchihocphi","tenkhoavien")
      return [false,dem,"Thiếu cột dữ liệu, cần có: mahocphan,tenhocphan,trongso,tinchi,tinchihocphi,tenkhoavien"] if hp_hash.length!=6      
      khoavien=Khoavien.find_by_tenkhoavien(hp_hash["tenkhoavien"])
      return [false,dem,"Tên khoa viện không tồn tại"] unless khoavien
      hp_hash["khoavien_id"]=khoavien.id
      hp_hash.except! "tenkhoavien"
      hocphan=Hocphan.find_by(mahocphan: hp_hash["mahocphan"])                
      if hocphan
        return [false,dem,hocphan.errors.full_messages.join(',')] unless hocphan.update(hp_hash)
      else                      
        new_hocphan=Hocphan.new(hp_hash)          
        return [false,dem,new_hocphan.errors.full_messages.join(',')] unless new_hocphan.save
      end # if hocphan                   
    end # end CSV.foreach
    return [true,dem,""]
  end
end
