class Lophoc < ApplicationRecord    
  require 'csv'
  belongs_to :giaovien
  belongs_to :hocphan
  belongs_to :hocki
  has_many :dangkilophocs, dependent: :destroy
  has_many :sinhviens ,through: :dangkilophocs
  validates :thoigian, presence: true, numericality: { only_integer: true ,:greater_than=>0,:message => " is empty " }
  validates :diadiem, presence: true, length: { maximum: 50}
  validates :malophoc, presence: true, length: { maximum: 10 }, uniqueness: true
  validates :maxdangki, presence: true, numericality: { only_integer: true, :greater_than=>0, :less_than_or_equal_to=>200 }
  default_scope {order(:malophoc)}
  def self.import(file)
      dem=1
      CSV.foreach(file.path, { headers: true, :col_sep => ';' }) do |row|
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
          x=Lophoc.new(lh_hash)
          r=Lophoc.lophocOk(x)
          if r.first
            begin         
              lh.update_attributes(lh_hash)              
            rescue
              return [false,dem,"Lỗi thông tin khi cập nhật"]
            end
          else
            return [false,dem,r.last]
          end
        else                      
          x=Lophoc.new(lh_hash)
          r=Lophoc.lophocOk(x)
          if r.first
            if x.save          
              
            else
              return [false,dem,x.errors.full_messages]
            end
          else
            return [false,dem,r.last]
          end          
        end # end if !product.nil? 
        dem+=1       
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
  
  def self.lophocOk(lophoc)
    diadiem=lophoc.diadiem
    giaovien=lophoc.giaovien
    lop=Lophoc.find_by(malophoc:lophoc.malophoc)
    if lop
      return [false,"Lop hoc da co sinh vien dang ki, khong the thay doi dia diem , thoi gian, hoc phan, hoc ki"] if (lop.diadiem!=lophoc.diadiem||lop.thoigian!=lophoc.thoigian||lop.hocphan_id!=lophoc.hocphan_id||lop.hocki_id!=lophoc.hocki_id)&&lop.dangkilophocs.count>0    
      return [false,"So sinh vien dang ki da max, khong the thu hep"] if lop.maxdangki>lophoc.maxdangki&&lop.dangkilophocs.count>lophoc.maxdangki
    end
    lophocs=Lophoc.where("hocki_id=? and diadiem=? and malophoc!=?",lophoc.hocki_id,diadiem,lophoc.malophoc)
    lophocs.each do |lh|
      return [false,"Phong hoc #{diadiem} da duoc su dung cho lop #{lh.malophoc}."] if lh.thoigian&lophoc.thoigian>0
    end   
    lophocs=giaovien.lophocs.where("hocki_id=? and malophoc!=?",lophoc.hocki_id,lophoc.malophoc)
    lophocs.each do |lh|
      return [false,"Giao vien #{giaovien.tengiaovien} bi trung lich day voi lop(#{lh.malophoc})."] if lh.thoigian&lophoc.thoigian>0
    end 
    return [true,""]  
  end
end
