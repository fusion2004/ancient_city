class TripsController < ApplicationController

  def show
    @trip = TripPresenter.new(Trip.find(params[:id]))
    @hotels = @trip.hotels.map { |hotel| HotelPresenter.new(hotel) }
    @activities = @trip.activities.map { |activity| ActivityPresenter.new(activity) }
  end

end
