class ActivityPresenter < SimpleDelegator

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::FormTagHelper

  def initialize(activity)
    super(activity)
  end

  def short_description
    "#{name}: #{description} (#{number_to_currency(price)})"
  end

  def booking_check_box_tag
    check_box_tag(:"activity_id[]", id, false, id: "activity_id_#{id}")
  end

end
