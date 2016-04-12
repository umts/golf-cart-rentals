FactoryGirl.define do
  factory :rental do
    user_id 0
    department_id 0
    sequence(:reservation_id)
    item_type_id 0
    start_date Time.zone.today
    end_date Time.zone.today
  end

  factory :invalid_rental, parent: :rental do
    start_date nil
  end

  factory :new_rental, parent: :rental do
    user_id nil
    department_id nil
    reservation_id nil
    item_type_id { create(:item_type).id }
    start_date Time.zone.today.to_s
    end_date Time.zone.today.to_s
  end
end
