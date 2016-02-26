require 'rails_helper'

RSpec.describe "item_types/show", type: :view do
  before(:each) do
    @item_type = assign(:item_type, ItemType.create!(
      :name => "Name",
      :string => "String",
      :fee_schedule => "Fee Schedule",
      :references => "References"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/String/)
    expect(rendered).to match(/Fee Schedule/)
    expect(rendered).to match(/References/)
  end
end
