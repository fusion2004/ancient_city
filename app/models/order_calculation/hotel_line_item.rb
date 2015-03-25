module OrderCalculation
  class HotelLineItem < LineItem

    def actual_processing_fee
      unit_price > Money.new(25000) ? Money.new(1000) : Money.zero
    end

  private

    def coupon_code_applies?
      super() || (coupon_code && coupon_code.applies_to == "hotels")
    end

  end
end
