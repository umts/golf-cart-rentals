if Rails.env.development?
  puts "*****************************"
  puts "Seeding development"
  puts "*****************************"
  puts 'Creating groups'

  groups = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'groups.yml'))
  groups.each do |group|
    Group.where(name: group['name'], description: group['description']).first_or_create
  end

  puts "Creating users"
  users = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'users.yml'))
  users.each do |user|
    u = User.where(spire_id: user["spire_id"]).first_or_create user
  end

  puts 'Putting users in admin group'
  admin = Group.find_by name: 'admin'
  GroupsUser.where(group: admin, user: User.first).first_or_create

  puts "Creating Model Item Type"
  ######


  #need to add the name of golf car later
  puts "Setting up the Fee Schedule"
  fee_schedules = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'fee_schedules.yml'))
  fee_schedules.each do |fee_schedule|
    FeeSchedule.where(base_amount: fee_schedule['base_amount'], amount_per_day: fee_schedule['amount_per_day']).first_or_create
  end

  puts " "
end

puts "*****************************"
puts "Seeding all environments\n"
puts "*****************************"
puts 'Updating permissions'
admin = Group.find_by name: 'admin'
Permission.update_permissions_table

puts 'Giving all permissions to admin'
Permission.all.each do |p|
  GroupsPermission.where(group: admin, permission: p).first_or_create
end

puts "\nDone :D\n\n"
