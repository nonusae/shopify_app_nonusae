class RecurringApplicationChargesController < AuthenticatedController

  before_action :load_current_recurring_charge

  def show
    @shop_domain=params[:shop_doamin]
  end

  def create
    @shop_doamin = params[:shop_doamin]
    @recurring_application_charge.try!(:cancel)

    @recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new(recurring_application_charge_params)
    @recurring_application_charge.test = true
    url = callback_recurring_application_charge_url.to_s+"&shop=#{@shop_domain}"
    @recurring_application_charge.return_url = url

    if @recurring_application_charge.save
      fullpage_redirect_to @recurring_application_charge.confirmation_url
    else
      flash[:danger] = @recurring_application_charge.errors.full_messages.first.to_s.capitalize
      redirect_to_correct_path(@recurring_application_charge)
    end
  end

  def customize
    @recurring_application_charge.customize(params[:recurring_application_charge])
    fullpage_redirect_to @recurring_application_charge.update_capped_amount_url
  end

  def callback
    @recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.find(params[:charge_id])
    if params[:shop].present?
      shop_domain = params[:shop]
      @shop = ShopifyShop.find_by_shop_domain(shop_domain)
    end

    if @recurring_application_charge.status == 'accepted'
      puts "activate"
      @recurring_application_charge.activate
    end
    puts "APP CHRAGES:" +@recurring_application_charge.to_s
    redirect_to_correct_path(@recurring_application_charge,@shop)
  end

  def destroy
    @recurring_application_charge.cancel

    flash[:success] = "Recurring application charge was cancelled successfully"

    redirect_to_correct_path(@recurring_application_charge)
  end

  private

  def load_current_recurring_charge
    @recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.current
  end

  def recurring_application_charge_params
    params.require(:recurring_application_charge).permit(
      :name,
      :price,
      :capped_amount,
      :terms,
      :trial_days
    )
  end

  def redirect_to_correct_path(recurring_application_charge,shop)
    if recurring_application_charge.try(:capped_amount)
      redirect_to usage_charge_path
    else
      redirect_to recurring_application_charge_path(shop_domain: shop.shop_domain)
    end
  end

end
