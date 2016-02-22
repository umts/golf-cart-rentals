FactoryGirl.define do
  factory :permission do |f|
    f.controller 'controller'
    f.action 'action'
    f.id_field 'user_id'
  end
end
