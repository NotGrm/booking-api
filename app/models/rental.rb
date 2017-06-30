# Rental class
#
# Attributes:
# - name
# - daily_rate
class Rental < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :daily_rate, presence: true, numericality: { greater_than: 0 }
end
