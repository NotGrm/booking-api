# Booking class
#
# Attributes:
# - client_email
# - start_at
# - end_at
# - price
class Booking < ApplicationRecord
  belongs_to :rental

  validates :client_email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :price, presence: true

  validate :end_at_is_greater_than_start_at

  private

  def end_at_is_greater_than_start_at
    errors.add(:end_at, "can't be less than start_at") if !end_at.blank? && !start_at.blank? && start_at > end_at
  end
end
