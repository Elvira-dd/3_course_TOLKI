class Admin::SubscriptionsController < ApplicationController
  load_and_authorize_resource

  def create
    @subscription = Subscription.new(subscription_params)

    respond_to do |format|
      if @subscription.save
        format.turbo_stream { render :show }
        # format.html { redirect_to root_path, notice: "You've just subscribed" }
      else
        format.html { redirect_to root_path, notice: "Some error" }
      end
    end
  end

  private
    def subscription_params
      params.require(:subscription).permit(:email)
    end

end
