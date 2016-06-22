require 'json'

class Inventory::Collection < Array
  def initialize(klass, arr)
    super(arr)
    @inventory_class = klass
  end

  def create(name)
    binding.pry
    @inventory_class.create(name)
  end

end
