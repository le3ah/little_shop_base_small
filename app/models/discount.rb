class Discount < ApplicationRecord
  validates_presence_of :discount_type
  validates :discount_amount, presence: true, numericality: {greater_than_or_equal_to: 1, only_integer: true}
  validates :quantity, presence: true, numericality: {greater_than_or_equal_to: 1, only_integer: true}
  belongs_to :user, foreign_key: 'merchant_id'
end
