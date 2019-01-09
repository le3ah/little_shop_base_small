class Dashboard::DiscountsController < Dashboard::BaseController

  def index
    @discounts = current_user.discounts
  end

  def new
    @merchant = current_user
    @discount = Discount.new
  end

  def create
    @merchant = current_user
    if @merchant.discounts == []
      @discount = @merchant.discounts.create(discount_params)
    else
      if @merchant.discounts.first.discount_type == discount_params[:discount_type]
        @discount = @merchant.discounts.create(discount_params)
      else
        flash[:notice] = "Discount types must match"
        @discount = Discount.new
      end
    end
    if @discount.save
      flash[:success] = "New discount created"
      redirect_to dashboard_discounts_path
    else
      flash[:error] = "New discount not created"
      render :new
    end
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
