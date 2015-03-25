module OrderCalculation
  class LineItem
    attr_reader :buyable, :unit_price, :amount, :coupon_code

    def initialize(buyable, unit_price, amount, coupon_code)
      @buyable, @unit_price, @amount, @coupon_code = buyable, unit_price, amount, coupon_code
    end

    def extended_price
      ext_price = unit_price * amount
      ext_price = ext_price * coupon_code.discount_multiplier if coupon_code_applies?
      ext_price
    end

    def processing_fee
      if extended_price == Money.zero
        Money.zero
      else
        actual_processing_fee
      end
    end

    def price_paid
      extended_price + processing_fee
    end

    def params
      params = { buyable: buyable, unit_price: unit_price, amount: amount,
        extended_price: extended_price, processing_fee: processing_fee,
        price_paid: price_paid, coupon_code: coupon_code }
    end

  private

    def coupon_code_applies?
      coupon_code && coupon_code.applies_to == "all"
    end

  end
end
