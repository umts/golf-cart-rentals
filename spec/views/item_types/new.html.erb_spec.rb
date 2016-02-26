require 'rails_helper'

RSpec.describe "item_types/new", type: :view do
  before(:each) do
    assign(:item_type, ItemType.new(
      :name => "MyString",
      :string => "MyString",
      :fee_schedule => "MyString",
      :references => "MyString"
    ))
  end

  it "renders new item_type form" do
    render

    assert_select "form[action=?][method=?]", item_types_path, "post" do

      assert_select "input#item_type_name[name=?]", "item_type[name]"

      assert_select "input#item_type_string[name=?]", "item_type[string]"

      assert_select "input#item_type_fee_schedule[name=?]", "item_type[fee_schedule]"

      assert_select "input#item_type_references[name=?]", "item_type[references]"
    end
  end
end
