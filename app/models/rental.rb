# Rental class
#
# Attributes:
# - name
# - daily_rate
class Rental < ApplicationRecord
  has_many :bookings

  validates :name, presence: true, uniqueness: true
  validates :daily_rate, presence: true, numericality: { greater_than: 0 }

  def available?(period_start, period_end)
    bookings.end_after(period_start).start_before(period_end).empty?
  end
end
