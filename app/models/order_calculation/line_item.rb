module OrderCalculation
  class LineItem
    attr_reader :buyable, :unit_price, :amount, :extended_price, :processing_fee

    def initialize(buyable, unit_price, amount)
      @buyable, @unit_price, @amount = buyable, unit_price, amount
      @extended_price = unit_price * amount
    end

    def price_paid
      extended_price + processing_fee
    end

    def params
      { buyable: buyable, unit_price: unit_price, amount: amount,
        extended_price: extended_price, processing_fee: processing_fee,
        price_paid: price_paid }
    end
  end
end
