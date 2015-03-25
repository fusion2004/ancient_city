module OrderCalculation
  class ActivityLineItem < LineItem
    def processing_fee
      Money.new(500)
    end
  end
end
