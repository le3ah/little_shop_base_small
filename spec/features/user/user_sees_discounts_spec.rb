require 'rails_helper'

include ActionView::Helpers::NumberHelper

describe 'as a registered user' do
  it "I see what dollar discounts apply to my order" do
    user_1 = create(:user)
    merchant_1 = create(:merchant)
    item_1 = create(:item, user: merchant_1, inventory: 20, price: 2)
    discount_1 = merchant_1.discounts.create(discount_type: "dollar", discount_amount: "10", quantity: "5")
    discount_2 = merchant_1.discounts.create(discount_type: "dollar", discount_amount: "20", quantity: "10")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)

    visit item_path(item_1.slug)
    click_button "Add to Cart"

    visit cart_path
    within "#item-#{item_1.id}" do
      expect(page).to have_content("#{merchant_1.name} offers: ")
      expect(page).to have_content("$#{discount_1.discount_amount} off of orders of $#{discount_1.quantity} or more")
      expect(page).to have_content("$#{discount_2.discount_amount} off of orders of $#{discount_2.quantity} or more")
      expect(page).to have_content("Subtotal: $2.00")
    end
  end
end
