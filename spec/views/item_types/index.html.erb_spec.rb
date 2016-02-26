require 'rails_helper'

RSpec.describe "item_types/index", type: :view do
  before(:each) do
    assign(:item_types, [
      ItemType.create!(),
      ItemType.create!()
    ])
  end

  it "renders a list of item_types" do
    render
  end
end
