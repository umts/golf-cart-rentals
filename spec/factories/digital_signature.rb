FactoryGirl.define do
  factory :digital_signature do
    association :rental
    image 'fake image'
    intent :check_out
    author :csr
  end
end
