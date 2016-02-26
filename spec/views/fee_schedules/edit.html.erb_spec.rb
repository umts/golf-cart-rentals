require 'rails_helper'

RSpec.describe "fee_schedules/edit", type: :view do
  before(:each) do
    @fee_schedule = assign(:fee_schedule, FeeSchedule.create!(
      :base_amount => "",
      :amount_per_day => ""
    ))
  end

  it "renders the edit fee_schedule form" do
    render

    assert_select "form[action=?][method=?]", fee_schedule_path(@fee_schedule), "post" do

      assert_select "input#fee_schedule_base_amount[name=?]", "fee_schedule[base_amount]"

      assert_select "input#fee_schedule_amount_per_day[name=?]", "fee_schedule[amount_per_day]"
    end
  end
end
