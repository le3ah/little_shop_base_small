class Discount < ApplicationRecord
  belongs_to :user, foreign_key: 'merchant_id'
end
