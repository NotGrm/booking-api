FactoryGirl.define do
  factory :booking do
    client_email 'email@example.org'
    start_at '2017-06-30'
    end_at '2017-07-01'
    rental
  end
end
