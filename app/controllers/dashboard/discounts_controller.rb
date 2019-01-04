class Dashboard::DiscountsController < Dashboard::BaseController
  def index
    @discounts = current_user.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    @merchant = current_user
    @discount = @merchant.discounts.create(discount_params)
    redirect_to dashboard_discounts_path
  end

  private

  def discount_params
    params.require(:discount).permit(:discount_type, :discount_amount, :quantity)
  end
end
