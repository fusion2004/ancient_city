module OrderCalculation
  class LineItem
    attr_reader :buyable, :unit_price, :amount, :extended_price, :processing_fee

    def initialize(buyable, unit_price, amount)
      @buyable, @unit_price, @amount = buyable, unit_price, amount
      @extended_price = unit_price * amount
    end

    def params
      { buyable: buyable, unit_price: unit_price, amount: amount,
      extended_price: amount * unit_price, processing_fee: processing_fee }
    end
  end
end
