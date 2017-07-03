# Booking resource
class Api::BookingResource < JSONAPI::Resource
  attributes :client_email, :start_at, :end_at, :price

  relationship :rental, to: :one, always_include_linkage_data: true

  def self.updatable_fields(context)
    super - [:price]
  end

  def self.creatable_fields(context)
    super - [:price]
  end
end
