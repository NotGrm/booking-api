FactoryGirl.define do
  factory :booking do
    client_email 'email@example.org'
    price 1
    start_at '2017-06-30'
    end_at '2017-06-30'
    rental
  end
end
