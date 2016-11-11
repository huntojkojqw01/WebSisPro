class Lophoc < ApplicationRecord
  belongs_to :hocphan
  belongs_to :giaovien
  has_many :dkilops
end
