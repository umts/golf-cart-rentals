require 'rails_helper'

RSpec.describe "item_types/edit", type: :view do
  before(:each) do
    @item_type = assign(:item_type, ItemType.create!(
      :name => "MyString",
      :string => "MyString",
      :fee_schedule => "MyString",
      :references => "MyString"
    ))
  end

  it "renders the edit item_type form" do
    render

    assert_select "form[action=?][method=?]", item_type_path(@item_type), "post" do

      assert_select "input#item_type_name[name=?]", "item_type[name]"

      assert_select "input#item_type_string[name=?]", "item_type[string]"

      assert_select "input#item_type_fee_schedule[name=?]", "item_type[fee_schedule]"

      assert_select "input#item_type_references[name=?]", "item_type[references]"
    end
  end
end
