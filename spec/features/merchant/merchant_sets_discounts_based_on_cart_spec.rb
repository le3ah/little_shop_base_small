require 'rails_helper'

describe  'as a merchant' do
  context 'I visit my dashboard page' do
    it "should click a link to create a bulk discount - percentage" do
      merchant_10 = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_10)

      visit dashboard_path

      click_on "View Bulk Discounts"

      expect(current_path).to eq(dashboard_discounts_path)

      expect(page).to have_content("Bulk Discounts")

      click_link("Create Bulk Discount")

      expect(current_path).to eq(new_dashboard_discount_path)

      fill_in :discount_discount_type, with: "percentage"
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

      fill_in :discount_discount_type, with: "dollar"
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
    it "should not be able to add dollar discount if existing percentage discount for merchant" do
      merchant_1 = create(:merchant)
      discount_1 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: "10", quantity: "5")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

      visit dashboard_discounts_path

      click_link("Create Bulk Discount")
      expect(current_path).to eq(new_dashboard_discount_path)

      fill_in :discount_discount_type, with: "dollar"
      fill_in :discount_discount_amount, with: 5
      fill_in :discount_quantity, with: 50
      click_on 'Create Discount'

      expect(page).to have_content("Discount types must match")
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
    it "should update a discount" do
      merchant_1 = create(:merchant)
      discount_1 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: "10", quantity: "5")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

      visit dashboard_discounts_path

      within "#discount-#{discount_1.id}" do
        click_link "Edit Discount #{discount_1.id}"
      end
      expect(current_path).to eq(edit_dashboard_discount_path(discount_1))

      fill_in :discount_discount_amount, with: 25
      fill_in :discount_quantity, with: 10
      click_on 'Update Discount'

      expect(current_path).to eq(dashboard_discounts_path)
      expect(page).to have_content('Discount updated')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1.reload)

      visit dashboard_discounts_path
      within "#discount-#{discount_1.id}" do
        expect(page).to have_content("Discount Type: percentage")
        expect(page).to have_content("Discount Amount: 25%")
        expect(page).to have_content("Item Quantity: 10")
      end
    end
    it "should not update if full information is not completed" do
      merchant_1 = create(:merchant)
      discount_1 = merchant_1.discounts.create(discount_type: "percentage", discount_amount: "10", quantity: "5")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

      visit dashboard_discounts_path

      within "#discount-#{discount_1.id}" do
        click_link "Edit Discount #{discount_1.id}"
      end
      expect(current_path).to eq(edit_dashboard_discount_path(discount_1))

      fill_in :discount_discount_amount, with: 25
      fill_in :discount_quantity, with: 0

      click_on 'Update Discount'

      expect(current_path).to eq(dashboard_discount_path(discount_1))
      expect(page).to have_content('Discount update failed')
    end
    it "should create a new bulk discount when one exists - dollar" do
      merchant_1 = create(:merchant)
      discount_1 = merchant_1.discounts.create(discount_type: "dollar", discount_amount: "10", quantity: "5")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_1)

      visit dashboard_discounts_path

      click_link("Create Bulk Discount")
      expect(current_path).to eq(new_dashboard_discount_path)

      fill_in :discount_discount_type, with: "dollar"
      fill_in :discount_discount_amount, with: 20
      fill_in :discount_quantity, with: 10
      click_on 'Create Discount'
      last_discount = Discount.last
      expect(current_path).to eq(dashboard_discounts_path)

      within "#discount-#{last_discount.id}" do
        expect(page).to have_content("Discount ID: #{last_discount.id}")
        expect(page).to have_content("Discount Type: dollar")
        expect(page).to have_content("Discount Amount: $20")
        expect(page).to have_content("Dollar Limit: $10")
      end
    end
  end
end
