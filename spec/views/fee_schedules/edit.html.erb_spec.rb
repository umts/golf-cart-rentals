require 'rails_helper'

RSpec.describe "fee_schedules/edit", type: :view do
  before(:each) do
    @fee_schedule = assign(:fee_schedule, FeeSchedule.create!())
  end

  it "renders the edit fee_schedule form" do
    render

    assert_select "form[action=?][method=?]", fee_schedule_path(@fee_schedule), "post" do
    end
  end
end
