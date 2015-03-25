module OrderCalculation
  class TripLineItem < LineItem
    def initialize(*args)
      super
      centuries_past = (Date.today.year - buyable.start_date.year) / 100
      @processing_fee = Money.new(1000) + Money.new(centuries_past * 100)
    end
  end
end
