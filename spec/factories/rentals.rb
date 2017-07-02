FactoryGirl.define do
  factory :rental do
    sequence :name do |n|
      "rental#{n}"
    end
    daily_rate 100
  end
end
