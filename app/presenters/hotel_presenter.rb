class HotelPresenter < SimpleDelegator

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::FormTagHelper

  def initialize(hotel)
    super(hotel)
  end

  def short_description
    "#{name}: #{description} (#{number_to_currency(price)})"
  end

  def booking_radio_button_tag
    radio_button_tag(:hotel_id, id, false)
  end

end
