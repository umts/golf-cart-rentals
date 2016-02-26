require 'rails_helper'

RSpec.describe "item_types/index", type: :view do
  before(:each) do
    assign(:item_types, [
      ItemType.create!(
        :name => "Name",
        :string => "String",
        :fee_schedule => "Fee Schedule",
        :references => "References"
      ),
      ItemType.create!(
        :name => "Name",
        :string => "String",
        :fee_schedule => "Fee Schedule",
        :references => "References"
      )
    ])
  end

  it "renders a list of item_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "String".to_s, :count => 2
    assert_select "tr>td", :text => "Fee Schedule".to_s, :count => 2
    assert_select "tr>td", :text => "References".to_s, :count => 2
  end
end
