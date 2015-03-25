module OrderCalculation
  class TripLineItem < LineItem

    def actual_processing_fee
      Money.new(1000) + Money.new(centuries_past * 100)
    end

  private

    def centuries_past
      (Date.today.year - buyable.start_date.year) / 100
    end

    def coupon_code_applies?
      super() || (coupon_code && coupon_code.applies_to == "trips")
    end

  end
end
