class Sinhvien < ApplicationRecord
  belongs_to :user
  has_many :dkilops
end
