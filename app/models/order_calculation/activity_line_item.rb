module OrderCalculation
  class ActivityLineItem < LineItem

    def actual_processing_fee
      Money.new(500)
    end

  private

    def coupon_code_applies?
      super() || (coupon_code && coupon_code.applies_to == "activities")
    end

  end
end
