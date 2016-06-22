if Rails.env.development?
  puts '*****************************'
  puts 'Seeding development'
  puts '*****************************'
  puts 'Creating groups'

  groups = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'groups.yml'))
  groups.each do |group|
    Group.where(name: group['name'], description: group['description']).first_or_create
  end

  puts 'Creating departments'
  departments = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'departments.yml'))
  departments.each do |department|
    Department.where(name: department['name'], active: true).first_or_create
  end

  puts 'Creating users'
  users = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'users.yml'))
  users.each do |user|
    u = User.where(spire_id: user['spire_id']).first_or_create user
  end

  puts 'Putting users in admin group'
  admin = Group.find_by name: 'admin'
  GroupsUser.where(group: admin, user: User.first).first_or_create

  puts 'Putting users in Parking department'
  parking = Department.find_by name: 'Parking'
  parking.users << User.first

  puts 'Creating Model Item Type'
  item_types = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'item_types.yml'))
  item_types.each do |item_type|
    Inventory.create_item_type(item_type['name']) unless Inventory.item_types.each_with_object([]) {|item_type, memo| memo << item_type['name']}.include?(item_type['name'])
    ItemType.where(base_fee: item_type['base_fee'], fee_per_day: item_type['fee_per_day'], name: item_type['name'], disclaimer: item_type['disclaimer']).first_or_create
  end

  puts 'Create Model Rental'

end

puts '*****************************'
puts "Seeding all environments\n"
puts '*****************************'
puts 'Updating permissions'
admin = Group.find_by name: 'admin'
Permission.update_permissions_table

puts 'Giving all permissions to admin'
Permission.all.each do |p|
  GroupsPermission.where(group: admin, permission: p).first_or_create
end

puts "\nDone :D\n\n"
