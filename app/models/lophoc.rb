class Lophoc < ApplicationRecord  
  belongs_to :giaovien
  belongs_to :hocphan
  belongs_to :hocki
  has_many :dangkilophocs, dependent: :destroy
  has_many :sinhviens ,through: :dangkilophocs
  validates :thoigian, presence: true, numericality: { only_integer: true ,:greater_than=>0,:message => " is empty " }
  validates :diadiem, presence: true, length: { maximum: 50}
  validates :malophoc, presence: true, length: { maximum: 10 }, uniqueness: true
  validates :maxdangki, presence: true, numericality: { only_integer: true, :greater_than=>0, :less_than_or_equal_to=>200 }
  def self.import(file)
      dem=0
      CSV.foreach(file.path, { headers: true, :col_sep => ';' }) do |row|
        lophoc_hash = row.to_hash.except("id")        
        lh = Lophoc.where(malophoc: lophoc_hash["malophoc"])
        giaovien=Giaovien.find_by(tengiaovien: lophoc_hash["tengiaovien"])
        hocphan=Hocphan.find_by(mahocphan: lophoc_hash["mahocphan"])
        hocki=Hocki.find_by(mahocki: lophoc_hash["mahocki"])
        if giaovien && hocphan && hocki
          lophoc_hash.except!("tengiaovien","mahocphan","mahocki")          
          lophoc_hash["giaovien_id"]=giaovien.id
          lophoc_hash["hocphan_id"]=hocphan.id
          lophoc_hash["hocki_id"]=hocki.id          
          lophoc_hash["thoigian"]=Lophoc.convertTime(lophoc_hash["thoigian"])          
          if lh.count == 1            
            lh.first.update_attributes(lophoc_hash)
          else                      
            Lophoc.create!(lophoc_hash)          
          end # end if !product.nil?
          dem+=1
        end
      end # end CSV.foreach
      return dem
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
