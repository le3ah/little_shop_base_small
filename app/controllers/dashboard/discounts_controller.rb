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

  def destroy
    @discount = Discount.find(params[:id])
    @discount.destroy
    redirect_to dashboard_discounts_path
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    if @discount.save
      flash[:success] = 'Discount updated'
      redirect_to dashboard_discounts_path
    else
      flash[:error] = 'Discount update failed'
      render :edit
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:discount_type, :discount_amount, :quantity)
  end
end
