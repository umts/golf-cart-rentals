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
  parking.users << User.all

  puts 'Creating Model Item Type'
  item_types = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'item_types.yml'))
  item_types.each do |item_type|
    inv_item_types = Inventory.item_types.each_with_object({}) do |i, memo|
      memo[ i['name'] ] = i['uuid']
    end

    unless inv_item_types.keys.include?(item_type['name'])
      Inventory.create_item_type(item_type['name'])
      inv_item_types = Inventory.item_types.each_with_object({}) do |i, memo|
        memo[ i['name'] ] = i['uuid']
      end
    end

    item_type[:uuid] = inv_item_types[item_type['name']]
    type = ItemType.where(item_type).first_or_create
  end

  # Could have done in the above loop, but that was getting a bit messy
  puts 'Creating Items in the API, by Item Type'
  items = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'items.yml'))
  item_types = ItemType.all
  if Inventory.items_by_type(item_types.first.uuid).empty?
    items[0..9].each do |item|
      Inventory.create_item(item_types.first.uuid, item["name"], true, {})
    end
  end
  if Inventory.items_by_type(item_types.last.uuid).empty?
    items[10..19].each do |item|
      Inventory.create_item(item_types.last.uuid, item["name"], true, {})
    end
  end

  puts 'Pulling Items from Api and Storing Locally'
  ItemType.all.each do |item_type|
    Inventory.items_by_type(item_type.uuid).each do |item|
      Item.create(name: item["name"], item_type_id: item_type.id, uuid: item["uuid"])
    end
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
