class PurchasesOrder

  attr_accessor :length_of_stay

  def initialize(trip_id, hotel_id, activity_ids, length_of_stay)
    @trip_id, @hotel_id, @activity_ids = trip_id, hotel_id, activity_ids
    @length_of_stay = length_of_stay
  end

  def trip
    @trip ||= Trip.find(@trip_id)
  end

  def hotel
    @hotel ||= Hotel.find(@trip_id)
  end

  def activities
    @activities ||= @activity_ids.map { |id| Activity.find(id) }
  end

  def order
    @order ||= Order.new
  end

  def add_line_item(buyable, unit_price, amount)
    line_item_params = OrderCalculation.for(buyable, unit_price, amount).params
    order.order_line_items.new(line_item_params)
  end

  def run
    add_line_item(trip, trip.price, 1)
    add_line_item(hotel, hotel.price, length_of_stay.to_i)
    activities.each { |a| add_line_item(a, a.price, 1) }
    order.total_price_paid = order.order_line_items.map(&:extended_price).sum +
      order.order_line_items.map(&:processing_fee).sum
    order.save
  end

end
