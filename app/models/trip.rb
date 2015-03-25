class Trip < ActiveRecord::Base
  has_many :activities
  has_many :hotels

  monetize :price_cents

  def length_of_stay
    end_date - start_date
  end

end
