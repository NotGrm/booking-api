require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'Respond to' do
    it { is_expected.to respond_to(:client_email) }
    it { is_expected.to respond_to(:start_at) }
    it { is_expected.to respond_to(:end_at) }
    it { is_expected.to respond_to(:price) }
  end

  describe 'validations' do
    let(:valid_dates_booking) { build(:booking, start_at: Date.parse('2017-06-30'), end_at: Date.parse('2017-07-01')) }
    let(:invalid_dates_booking) { build(:booking, start_at: '2017-06-30', end_at: '2017-06-29') }
    let(:valid_email_booking) { build(:booking, client_email: 'valid-email@example.org') }
    let(:invalid_email_booking) { build(:booking, client_email: 'invalid-email@example') }

    it { is_expected.to validate_presence_of(:client_email) }

    it 'validates that :client_email is a valid email' do
      expect(valid_email_booking).to be_valid
    end

    it 'does not validate if :client_email is not a valid email' do
      expect(invalid_email_booking).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:start_at) }

    it { is_expected.to validate_presence_of(:end_at) }

    it 'validates if :end_at is greater than :start_at' do
      expect(valid_dates_booking).to be_valid
    end

    it 'does not validate if :end_at is less than :start_at' do
      expect(invalid_dates_booking).not_to be_valid
    end

    it { is_expected.to validate_presence_of(:price) }

    it 'validates that rental is available' do
      rental = create(:rental) do |r|
        create(:booking, rental: r, start_at: '2017-07-02', end_at: '2017-07-03')
      end

      booking = build(:booking, rental: rental, start_at: '2017-07-02', end_at: '2017-07-03')
      expect(booking).not_to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:rental) }
  end
end
