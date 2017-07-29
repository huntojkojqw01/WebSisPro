class Lophoc < ApplicationRecord    
  require 'csv'
  belongs_to :giaovien
  belongs_to :hocphan
  delegate :mahocphan,:tenhocphan,:tinchi,:tinchihocphi,:tenkhoavien,:trongso,to: :hocphan
  belongs_to :hocki
  delegate :mahocki,to: :hocki
  has_many :dangkilophocs, dependent: :destroy    
  has_many :sinhviens ,through: :dangkilophocs
  validates :hocphan_id,:hocki_id,:giaovien_id, presence: true  
  validates :thoigian, presence: true, numericality: { only_integer: true ,:greater_than=>0}
  validates :diadiem, presence: true, length: { maximum: 50}
  validates :malophoc, presence: true, length: { maximum: 10 }, uniqueness: true
  validates :maxdangki, presence: true, numericality: { only_integer: true, :greater_than=>0, :less_than_or_equal_to=>200 }
  validate :lophoc_validate
  default_scope {order(:malophoc)}
  def lophoc_validate
    giaovien=Giaovien.find_by_id(giaovien_id)
    lop=Lophoc.find_by(malophoc: malophoc)
    if lop
      errors.add(:hocki_id, :unabledit) if lop.hocki_id!=hocki_id&&lop.dangkilophocs.count>0
      errors.add(:diadiem, :unabledit) if lop.diadiem!=diadiem&&lop.dangkilophocs.count>0
      errors.add(:thoigian, :unabledit) if lop.thoigian!=thoigian&&lop.dangkilophocs.count>0
      errors.add(:hocphan_id, :unabledit) if lop.hocphan_id!=hocphan_id&&lop.dangkilophocs.count>0    
      errors.add(:maxdangki, :unablesmall) if lop.maxdangki>maxdangki&&lop.dangkilophocs.count>maxdangki
    end
    lophocs=Lophoc.where("hocki_id=? and diadiem=? and malophoc!=?",hocki_id,diadiem,malophoc)
    lophocs.each do |lh|
      errors.add(:diadiem, :isusing) if lh.thoigian&thoigian>0
    end
    if giaovien   
      lophocs=giaovien.lophocs.where("hocki_id=? and malophoc!=?",hocki_id,malophoc)
      lophocs.each do |lh|
        errors.add(:giaovien_id, :isteaching)  if lh.thoigian&thoigian>0
      end
    end    
  end    
  def self.import(file)
    dem=0
    CSV.foreach(file.path, { headers: true, :col_sep => ';' }).with_index do |row,i|
      dem=i+2
      lh_hash = row.to_hash.slice("malophoc","maxdangki","thoigian","diadiem","magiaovien","mahocphan","mahocki")
        return [false,dem,"Thiếu cột dữ liệu, cần có: malophoc;maxdangki;thoigian;diadiem;magiaovien;mahocphan;mahocki"] if lh_hash.length!=7       
      lh = Lophoc.find_by(malophoc: lh_hash["malophoc"])
      hocphan=Hocphan.find_by(mahocphan: lh_hash["mahocphan"])        
        return [false,dem,"Mã học phần không tồn tại"] if hocphan==nil
      hocki=Hocki.find_by(mahocki: lh_hash["mahocki"])
        return [false,dem,"Mã học kì không tồn tại"] if hocki==nil
      giaovien=Giaovien.find_by(magiaovien: lh_hash["magiaovien"])
        return [false,dem,"Mã giáo viên không tồn tại"] if giaovien==nil          
              
      lh_hash.except!("magiaovien","mahocphan","mahocki")          
      lh_hash["giaovien_id"]=giaovien.id
      lh_hash["hocphan_id"]=hocphan.id
      lh_hash["hocki_id"]=hocki.id          
      lh_hash["thoigian"]=Lophoc.convertTime(lh_hash["thoigian"])          
      if lh
        return [false,dem,lh.errors.full_messages.join(',')] unless lh.update(lh_hash)
      else                      
        new_lh=Lophoc.new(lh_hash)
        return [false,dem,new_lh.errors.full_messages.join(',')] unless new_lh.save       
      end # end if lh           
    end # end CSV.foreach
    return [true,dem,""]
  end # end self.im
  def self.as_csv
    CSV.generate do |csv|
        csv << column_names
        all.each do |item|
          csv << item.attributes.values_at(*column_names)
        end
    end
  end
  def self.toIntTime(strTime)    
    x=strTime.split(",").collect {|k| k.to_i}
    return 0 if x.count!=3||x[0]<2||x[0]>6||x[1]<1||x[1]>12||x[2]<1||x[2]>12
    tmp=1
    x[1].upto(x[2]-1) do |m|
      tmp=(tmp<<1)+1      
    end
    return tmp<<(48-12*(x[0]-2)+12-x[2])
  end
  def self.convertTime(thoigian)
    t=0
    strTimes=thoigian.split('-')
    strTimes.each do |time|
      t|=Lophoc.toIntTime(time)
    end
    return t
  end  
end
