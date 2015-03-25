class OrdersController < ApplicationController

  def create
    action = PurchasesOrder.new(params[:trip_id], params[:hotel_id],
        params[:activity_id], params[:length_of_stay], params[:coupon_code])
    action.run
    redirect_to :root
  end

end
