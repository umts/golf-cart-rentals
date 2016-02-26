require 'rails_helper'

RSpec.describe "fee_schedules/new", type: :view do
  before(:each) do
    assign(:fee_schedule, FeeSchedule.new(
      :base_amount => "",
      :amount_per_day => ""
    ))
  end

  it "renders new fee_schedule form" do
    render

    assert_select "form[action=?][method=?]", fee_schedules_path, "post" do

      assert_select "input#fee_schedule_base_amount[name=?]", "fee_schedule[base_amount]"

      assert_select "input#fee_schedule_amount_per_day[name=?]", "fee_schedule[amount_per_day]"
    end
  end
end
