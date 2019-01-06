class Dashboard::DiscountsController < Dashboard::BaseController
  before_action :check_discount_type, only: [:new, :create]

  def index
    @discounts = current_user.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    @merchant = current_user
    @discount = @merchant.discounts.create(discount_params)
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
    if @merchant_discount_type
      params[:discount][:discount_type] = @merchant_discount_type
    end
    params.require(:discount).permit(:discount_type, :discount_amount, :quantity)
  end

  def check_discount_type

    if current_user.discounts.count > 0
      @merchant_discount_type = current_user.discounts.first.discount_type
    end
  end
end
