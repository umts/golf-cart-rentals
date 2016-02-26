require 'rails_helper'

RSpec.describe "item_types/new", type: :view do
  before(:each) do
    assign(:item_type, ItemType.new(
      :name => "MyString"
    ))
  end

  it "renders new item_type form" do
    render

    assert_select "form[action=?][method=?]", item_types_path, "post" do

      assert_select "input#item_type_name[name=?]", "item_type[name]"
    end
  end
end
