class Giaovien < ApplicationRecord
  belongs_to :user
  has_one :lophoc
end
