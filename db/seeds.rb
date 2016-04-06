if Rails.env.development?
  puts '*****************************'
  puts 'Seeding development'
  puts '*****************************'
  puts 'Creating groups'

  groups = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'groups.yml'))
  groups.each do |group|
    Group.where(name: group['name'], description: group['description']).first_or_create
  end

  puts 'Creating users'
  users = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'users.yml'))
  users.each do |user|
    u = User.where(spire_id: user['spire_id']).first_or_create user
  end

  puts 'Putting users in admin group'
  admin = Group.find_by name: 'admin'
  GroupsUser.where(group: admin, user: User.first).first_or_create

  puts 'Creating Model Item Type'
  item_types = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'item_types.yml'))
  item_types.each do |item_type|
    ItemType.where(base_fee: item_type['base_fee'], fee_per_day: item_type['fee_per_day'], name: item_type['name'], disclaimer: item_type['disclaimer']).first_or_create
  end

  #need to add the name of golf car later
  puts "Setting up the Fee Schedule"
  fee_schedules = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'fee_schedules.yml'))
  fee_schedules.each do |fee_schedule|
    item_type = ItemType.find_by(name: fee_schedule["type_name"])
    FeeSchedule.where(base_amount: fee_schedule['base_amount'], amount_per_day: fee_schedule['amount_per_day'], item_type: item_type).first_or_create
  end

  puts "Creating list of incidentals"
  incidentals = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'incidental_types.yml'))
  incidentals.each do |i|
    IncidentalType.where(name: i['name'],
                         description: i['description'],
                         base: i['base'],
                         modifier_amount: i['modifier_amount'],
                         modifier_description: i['modifier_description']).first_or_create
  end

  puts " "
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
