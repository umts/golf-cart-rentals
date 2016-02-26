require 'rails_helper'

RSpec.describe "item_types/show", type: :view do
  before(:each) do
    @item_type = assign(:item_type, ItemType.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
