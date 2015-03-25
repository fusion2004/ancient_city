module OrderCalculation
  class TripLineItem < LineItem
    def processing_fee
      Money.new(1000) + Money.new(centuries_past * 100)
    end

  private

    def centuries_past
      (Date.today.year - buyable.start_date.year) / 100
    end
  end
end
