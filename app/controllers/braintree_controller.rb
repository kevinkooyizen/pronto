class BraintreeController < ApplicationController
  def new
    @client_token = Braintree::ClientToken.generate
  end

  def checkout
    nonce_from_the_client = params[:checkout_form][:payment_method_nonce]

    result = Braintree::Transaction.sale(
     :amount => "10.00", #this is currently hardcoded
     :payment_method_nonce => nonce_from_the_client,
     :options => {
        :submit_for_settlement => true
      }
     )
    user = User.find_by_id(params[:checkout_form][:account_id])
    if result.success?
      user.update_attribute(:paid, true)
      redirect_to user_path(user), :flash => { :success => "Transaction successful!" }
    else
      redirect_to braintree_new_path(account_id: params[:account_id]), :flash => { :error => "Transaction failed. Please try again." }
    end
  end
end
