require 'rails_helper'

RSpec.describe 'Merchant Dashboard Orders show page' do
  it "should see applicable discounts on order show page" do

    merchant_1 = create(:merchant)
    user_1 = create(:user)
    item_1 = create(:item, user: merchant_1, inventory: 20, price: 2)
    discount_1 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: "10", quantity: "5")
    discount_2 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: "20", quantity: "10")
    order_1 = create(:order)
    order_item_1 = create(:order_item, quantity: 5, price: 2, item: item_1, order: order_1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

    visit dashboard_order_path(order_1)

    expect(page).to have_content("You've offered 10% off of")
    expect(page).to have_content("5 items or more")
  end
end
