yaml = 'config/special_permissions.yml'
if File.exist?(yaml)
  require "erb"
  SPECIAL_PERMS = YAML.load(ERB.new(IO.read(yaml)).result) || {}
end
