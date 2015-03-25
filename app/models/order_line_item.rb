class OrderLineItem < ActiveRecord::Base

  belongs_to :order
  belongs_to :buyable, polymorphic: true
  belongs_to :coupon_code, foreign_key: "promo_code_id"

  monetize :unit_price_cents, :extended_price_cents, :processing_fee_cents,
      :price_paid_cents, :discount_cents

end
