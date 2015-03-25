require "rails_helper"

describe "purchasing a trip" do

  let!(:mayflower) { Trip.create!(
      :name => "Mayflower Luxury Cruise",
      :tag_line => "Enjoy The Cruise That Started It All",
      :start_date => "September 6, 1620",
      :end_date => "November 21, 1620",
      :location => "Atlantic Ocean",
      :tag => "Cruising",
      :image_name => "mayflower.jpg",
      :description => "You'll take a scenic 66 day, 67 night cruise from England to Cape Cod. Come for the scurvy, stay for the starvation",
      :price => 1200) }

  before do
    Hotel.create!(
        :trip => mayflower,
        :name => "Deluxe Suite",
        :description => "A luxury suite. On the Mayflower. Really.",
        :price => 500,
        :remote_api_id => "abc123")

    Activity.create!(
        :trip => mayflower,
        :name => "Martha's Vineyard",
        :description => "Tour Martha's Vineyard",
        :price => 400)

    Activity.create!(
        :trip => mayflower,
        :name => "Special Boat Tour",
        :description => "Tour The Whole Boat",
        :price => 300)

    @ten_percent_off = CouponCode.create!(
      :discount_percentage => 10,
      :applies_to => "all",
      :code => "ten_percent_off"
    )

    @hundred_percent_off_activities = CouponCode.create!(
      :discount_percentage => 100,
      :applies_to => "activities",
      :code => "hundred_percent_off_activities"
    )
  end

  describe "basic process" do
    it "creates order and line item objects" do
      visit("/trips/#{mayflower.id}")
      select('4', :from => 'length_of_stay')
      choose("hotel_id_#{mayflower.hotels.first.id}")
      check("activity_id_#{mayflower.activities.first.id}")
      click_button("Order")
      order = Order.last
      expect(order.order_line_items.count).to eq(3)
      expect(order.order_line_items.map(&:buyable)).to eq(
          [mayflower, mayflower.hotels.first, mayflower.activities.first])
    end

    it "correctly puts pricing in the line item objects" do
      visit("/trips/#{mayflower.id}")
      select('4', :from => 'length_of_stay')
      choose("hotel_id_#{mayflower.hotels.first.id}")
      check("activity_id_#{mayflower.activities.first.id}")
      click_button("Order")
      order = Order.last
      expect(order.trip_item.unit_price).to eq(1200)
      expect(order.trip_item.amount).to eq(1)
      expect(order.trip_item.extended_price).to eq(1200)
      expect(order.trip_item.processing_fee).to eq(13)
      expect(order.hotel_item.unit_price).to eq(500)
      expect(order.hotel_item.amount).to eq(4)
      expect(order.hotel_item.extended_price).to eq(2000)
      expect(order.hotel_item.processing_fee).to eq(10)
      expect(order.activity_items.first.unit_price).to eq(400)
      expect(order.activity_items.first.amount).to eq(1)
      expect(order.activity_items.first.extended_price).to eq(400)
      expect(order.activity_items.first.processing_fee).to eq(5)

      expect(order.total_price_paid).to eq(3628)
    end

    it "correctly puts pricing in the line item objects with a coupon code for all" do
      visit("/trips/#{mayflower.id}")
      select('4', :from => 'length_of_stay')
      choose("hotel_id_#{mayflower.hotels.first.id}")
      check("activity_id_#{mayflower.activities.first.id}")
      fill_in("coupon_code", with: "ten_percent_off")
      click_button("Order")
      order = Order.last
      expect(order.trip_item.unit_price).to eq(1200)
      expect(order.trip_item.amount).to eq(1)
      expect(order.trip_item.extended_price).to eq(1080)
      expect(order.trip_item.processing_fee).to eq(13)
      expect(order.trip_item.coupon_code).to eq(@ten_percent_off)
      expect(order.hotel_item.unit_price).to eq(500)
      expect(order.hotel_item.amount).to eq(4)
      expect(order.hotel_item.extended_price).to eq(1800)
      expect(order.hotel_item.processing_fee).to eq(10)
      expect(order.hotel_item.coupon_code).to eq(@ten_percent_off)
      expect(order.activity_items.first.unit_price).to eq(400)
      expect(order.activity_items.first.amount).to eq(1)
      expect(order.activity_items.first.extended_price).to eq(360)
      expect(order.activity_items.first.processing_fee).to eq(5)
      expect(order.activity_items.first.coupon_code).to eq(@ten_percent_off)

      expect(order.total_price_paid).to eq(3268)
    end

    it "correctly puts pricing in the line item objects with a coupon code for activities" do
      visit("/trips/#{mayflower.id}")
      select('4', :from => 'length_of_stay')
      choose("hotel_id_#{mayflower.hotels.first.id}")
      check("activity_id_#{mayflower.activities.first.id}")
      fill_in("coupon_code", with: "hundred_percent_off_activities")
      click_button("Order")
      order = Order.last
      expect(order.trip_item.unit_price).to eq(1200)
      expect(order.trip_item.amount).to eq(1)
      expect(order.trip_item.extended_price).to eq(1200)
      expect(order.trip_item.processing_fee).to eq(13)
      expect(order.trip_item.coupon_code).to eq(@hundred_percent_off_activities)
      expect(order.hotel_item.unit_price).to eq(500)
      expect(order.hotel_item.amount).to eq(4)
      expect(order.hotel_item.extended_price).to eq(2000)
      expect(order.hotel_item.processing_fee).to eq(10)
      expect(order.hotel_item.coupon_code).to eq(@hundred_percent_off_activities)
      expect(order.activity_items.first.unit_price).to eq(400)
      expect(order.activity_items.first.amount).to eq(1)
      expect(order.activity_items.first.extended_price).to eq(0)
      expect(order.activity_items.first.processing_fee).to eq(0)
      expect(order.activity_items.first.coupon_code).to eq(@hundred_percent_off_activities)

      expect(order.total_price_paid).to eq(3223)
    end
  end

end
