require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of :quantity }
    it { should validate_numericality_of(:quantity).only_integer }
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(1) }
  end

  describe 'relationships' do
    it { should belong_to :order }
    it { should belong_to :item }
  end

  describe 'class methods' do
  end

  describe 'instance methods' do
    it '#subtotal' do
      oi = create(:order_item, quantity: 5, price: 3)

      expect(oi.subtotal).to eq(15)
    end
    it "#discount_type" do
      merchant_1 = create(:merchant)
      item_1 = create(:item, user: merchant_1, inventory: 20, price: 2)
      discount_1 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: 10, quantity: 5)
      order_1 = create(:order)
      order_item_1 = create(:order_item, quantity: 5, price: 2, item: item_1, order: order_1)
      expect(order_item_1.discount_type).to eq(discount_1.discount_type)
    end

    it "#discount_subtotal" do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)
      item_1 = create(:item, user: merchant_1, inventory: 20, price: 2)
      item_2 = create(:item, user: merchant_3, inventory: 25, price: 3)
      item_4 = create(:item, user: merchant_1, inventory: 10, price: 2)
      item_3 = create(:item, user: merchant_2, inventory: 20, price: 2)
      discount_1 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: 10, quantity: 5)
      discount_2 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: 20, quantity: 10)
      discount_3 = merchant_2.discounts.create(discount_type: "dollar", discount_amount: 10, quantity: 50)

      order_1 = create(:order)
      order_2 = create(:order)
      order_item_1 = create(:order_item, quantity: 5, price: 2, item: item_1, order: order_1)
      order_item_2 = create(:order_item, quantity: 5, price: 2, item: item_4, order: order_1)
      order_item_3 = create(:order_item, quantity: 50, price: 2, item: item_3, order: order_2)
      order_item_4 = create(:order_item, quantity: 15, price: 3, item: item_2, order: order_2)

      expect(order_item_1.discount_subtotal).to eq(8)
      expect(order_item_2.discount_subtotal).to eq(8)

      expect(order_item_3.discount_subtotal).to eq(90)
      expect(order_item_4.discount_subtotal).to eq(45)
    end
    it "#discount_selector" do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      item_1 = create(:item, user: merchant_1, inventory: 20, price: 2)
      item_4 = create(:item, user: merchant_1, inventory: 10, price: 2)
      item_5 = create(:item, user: merchant_2, inventory: 10, price: 3)

      discount_1 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: 10, quantity: 5)
      discount_2 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: 25, quantity: 20)
      discount_3 = merchant_2.discounts.create(discount_type: "dollar", discount_amount: 10, quantity: 10)
      discount_4 = merchant_2.discounts.create(discount_type: "dollar", discount_amount: 40, quantity: 20)

      order_1 = create(:order)
      order_item_1 = create(:order_item, quantity: 5, price: 2, item: item_1, order: order_1)
      order_item_2 = create(:order_item, quantity: 15, price: 2, item: item_4, order: order_1)
      order_2 = create(:order)
      order_item_3 = create(:order_item, quantity: 6, price: 3, item: item_5, order: order_2)

      expect(order_item_1.discount_selector).to eq(discount_2)
      expect(order_item_3.discount_selector).to eq(discount_3)
    end
  end
end
