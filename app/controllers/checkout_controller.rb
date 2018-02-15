class CheckoutController < ApplicationController
  def confirm
  end

  def pay
    Payjp.api_key = PAYJP_SECRET_KEY
    charge = Payjp::Charge.create(
    :amount => 3500,
    :card => params['payjp-token'],
    :currency => 'jpy',
)
end
end
