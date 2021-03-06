class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }
  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1
  }

  def subtotal
    quantity * price
  end

  def discount_type
    unless item.user.discounts.empty?
      if item.user.discounts.first.discount_type == "dollar"
        "dollar"
      else
        "percentage"
      end
    end
  end

  def discount_selector
    item.user.discounts.map do |discount|
      if discount.quantity <= order.limit_selector(item.user.id)
        discount
      end
    end.reject(&:blank?).sort.last
  end

  def discount_subtotal
    if discount_selector == 0 || discount_selector == nil
      1 * subtotal
    elsif discount_selector.discount_type == "percentage"
      percent_off = (subtotal.to_f * (discount_selector.discount_amount.to_f / 100).to_f).round(2)
      subtotal - percent_off
    else
      subtotal - discount_selector.discount_amount
    end
  end
end
