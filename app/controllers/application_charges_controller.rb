class ApplicationChargesController < AuthenticatedController

  def index
    @application_charges = ShopifyAPI::ApplicationCharge.all || []
  end

  def create
    application_charge = ShopifyAPI::ApplicationCharge.new(params[:application_charge])
    application_charge.test = true
    application_charge.return_url = application_charges_url

    if application_charge.save
      flash[:success] = "One-time charge was successfully created"
      puts "Prepare for redirect_to !!!!!!!!!!"
      puts application_charge.confirmation_url
      render :layout => false, :inline => "<script>window.top.location = '#{application_charge.confirmation_url}';</script>"
    else
      flash[:danger] = application_charge.errors.full_messages.first.to_s.capitalize
      redirect_to application_charges_path
    end
  end

  def activate
    application_charge = ShopifyAPI::ApplicationCharge.find(params[:id])
    if application_charge.activate
      flash[:success] = "One-time charge has been activated"
    end

    redirect_to application_charges_path
  end

  private

  def application_charge_params
    params.require(:application_charge).permit(
      :name,
      :price
    )
  end

  def ajax_redirect_to(url)
      head 302, x_ajax_redirect_url: url
  end

end
