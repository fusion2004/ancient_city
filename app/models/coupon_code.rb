class CouponCode < ActiveRecord::Base
  has_many :order_line_items, foreign_key: "promo_code_id"

  def discount_multiplier
    (100 - discount_percentage) / 100.0
  end
end
