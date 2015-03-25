module OrderCalculation
  class ActivityLineItem < LineItem
    def initialize(*args)
      super
      @processing_fee = Money.new(500)
    end
  end
end
