require 'rails_helper'

RSpec.describe "item_types/new", type: :view do
  before(:each) do
    assign(:item_type, ItemType.new())
  end

  it "renders new item_type form" do
    render

    assert_select "form[action=?][method=?]", item_types_path, "post" do
    end
  end
end
