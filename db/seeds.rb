if Rails.env.development?
  puts "Creating users"
  users = YAML::load_file(File.join(Rails.root, 'db/db_yml', 'users.yml'))
  users.each do |user|
    u = User.where(spire: user["spire"]).first_or_create user
  end
  puts ''
end