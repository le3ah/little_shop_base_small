require 'rails_helper'

describe  'as a merchant' do
  context 'I visit my dashboard page' do
    it "should click a link to create a bulk discount - percentage" do
      merchant_1 = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

      visit dashboard_path

      click_on "View Bulk Discounts"

      expect(current_path).to eq(dashboard_discounts_path)

      expect(page).to have_content("Bulk Discounts")

      click_link("Create Bulk Discount")

      expect(current_path).to eq(new_dashboard_discount_path)

      discount_type = "percentage"

      fill_in :discount_discount_type, with: discount_type
      fill_in :discount_discount_amount, with: 10
      fill_in :discount_quantity, with: 5

      click_on 'Create Discount'
      last_discount = Discount.last
      expect(current_path).to eq(dashboard_discounts_path)

      within "#discount-#{last_discount.id}" do
        expect(page).to have_content("Discount Type: percentage")
        expect(page).to have_content("Discount Amount: 10%")
        expect(page).to have_content("Item Quantity: 5")
      end
    end
    it "should create a bulk discount - dollar" do
      merchant_1 = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

      visit dashboard_discounts_path

      click_link("Create Bulk Discount")
      expect(current_path).to eq(new_dashboard_discount_path)

      discount_type = "dollar"

      fill_in :discount_discount_type, with: discount_type
      fill_in :discount_discount_amount, with: 5
      fill_in :discount_quantity, with: 50
      click_on 'Create Discount'
      last_discount = Discount.last
      expect(current_path).to eq(dashboard_discounts_path)

      within "#discount-#{last_discount.id}" do
        expect(page).to have_content("Discount ID: #{last_discount.id}")
        expect(page).to have_content("Discount Type: dollar")
        expect(page).to have_content("Discount Amount: $5")
        expect(page).to have_content("Dollar Limit: $50")
      end
    end
    it "should delete a discount" do
      merchant_1 = create(:merchant)
      discount_1 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: "10", quantity: "5")
      discount_2 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: "20", quantity: "10")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

      visit dashboard_discounts_path
      within "#discount-#{discount_1.id}" do
        click_link("Delete Discount #{discount_1.id}")
      end
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1.reload)
      visit dashboard_discounts_path
      
      within "#discount-#{discount_2.id}" do
        expect(page).to have_content("Discount Type: percentage")
        expect(page).to have_content("Discount Amount: 20%")
        expect(page).to have_content("Item Quantity: 10")
      end
      expect(page).to_not have_content("Discount ID: #{discount_1.id}")
    end
  end
  # context "I see the user's cart at a certain quantity" do
  #   it "should apply bulk discount based on cart quantity to pending orders" do
  #     user_1 = create.(:user)
  #     merchant_1 = create.(:merchant)
  #     item = create(:item, user: merchant_1, inventory: 50)
  #     order_1 = create_list(:order, 2, user: user_1)
  #     create(:order_item, order: order_1[0], item: item, price: 1, quantity: 5)
  #     create(:order_item, order: order_1[1], item: item, price: 1, quantity: 5)
  #
  #
  #     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)
  #
  #     visit dashboard_path
  #     within '#orders' do
  #       expect(page).to_not have_content("You don't have any pending orders to fulfill")
  #       orders.each do |order|
  #         within "#order-#{order.id}" do
  #           expect(page).to have_link("Order ID #{order.id}")
  #           expect(page).to have_content("Created: #{order.created_at}")
  #           expect(page).to have_content("Items in Order: #{order.my_item_count(merchant.id)}")
  #           expect(page).to have_content("Value of Order: #{number_to_currency(order.my_revenue_value(merchant.id))}")
  #
  #           expect(page).to have_link("Apply Bulk Discount")
  #         end
  #       end
  #     end
  #   end
  # end
end
