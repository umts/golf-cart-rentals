FactoryGirl.define do

  factory :financial_transaction do
    rental
    #association :rental, factory: :rental_id
    #rental_id { create(:rental).id }
    #association :rental, factory: :transactable_id
    #transactable_id
    #transactable_type "Rental"
    amount 100
    adjustment 0
    created_at DateTime.now

    factory :incidental_type_transaction do
      transactable_type 'IncidentalType'
      #transactable_id 1
    end

    factory :fee_schedule_transaction do
      transactable_type 'FeeSchedule'
      #transactable_id 1
    end
  end
end
