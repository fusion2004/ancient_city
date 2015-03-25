module OrderCalculation
  class HotelLineItem < LineItem
    def processing_fee
      unit_price > Money.new(25000) ? Money.new(1000) : Money.zero
    end
  end
end
