Ransack.configure do |config|
  config.add_predicate 'full_name_cont',
  arel_predicate: 'cont',
  formatter: proc { |v| "#{first_name} #{last_name}" },
  validator: proc { |v| v.present? },
  type: :string
end
