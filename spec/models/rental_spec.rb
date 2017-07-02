require 'rails_helper'

RSpec.describe Rental, type: :model do
  describe 'Respond to' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:daily_rate) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }

    it { is_expected.to validate_presence_of(:daily_rate) }
    it { is_expected.to validate_numericality_of(:daily_rate).is_greater_than(0) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:bookings) }
  end

  describe 'methods' do
    describe '#available?' do
      subject(:rental) do
        create(:rental) do |rental|
          create(:booking, rental: rental, start_at: '2017-06-25', end_at: '2017-06-30')
          create(:booking, rental: rental, start_at: '2017-07-08', end_at: '2017-07-10')
        end
      end

      it 'return true when period starts after booking ends and ends before other booking starts' do
        expect(rental.available?('2017-06-30', '2017-07-08')).to be_truthy
      end

      it 'returns false when period match booking period' do
        expect(rental.available?('2017-06-25', '2017-06-30')).to be_falsy
      end

      it 'returns false when period starts before booking ends' do
        expect(rental.available?('2017-06-29', '2017-07-02')).to be_falsy
      end

      it 'returns false when period ends after booking starts' do
        expect(rental.available?('2017-07-01', '2017-07-09')).to be_falsy
      end
    end
  end
end
