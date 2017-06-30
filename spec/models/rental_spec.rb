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
end
