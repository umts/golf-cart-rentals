require 'rails_helper'

RSpec.describe "fee_schedules/index", type: :view do
  before(:each) do
    assign(:fee_schedules, [
      FeeSchedule.create!(
        :base_amount => "",
        :amount_per_day => ""
      ),
      FeeSchedule.create!(
        :base_amount => "",
        :amount_per_day => ""
      )
    ])
  end

  it "renders a list of fee_schedules" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
