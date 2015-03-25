module OrderCalculation
  LINE_ITEM_MAPPING = {
    ::Trip => TripLineItem,
    ::Hotel => HotelLineItem,
    ::Activity => ActivityLineItem
  }

  def self.for(buyable, unit_price, amount, coupon_code)
    LINE_ITEM_MAPPING[buyable.class].new(buyable, unit_price, amount, coupon_code)
  end
end
