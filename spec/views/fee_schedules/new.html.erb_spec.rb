require 'rails_helper'

RSpec.describe "fee_schedules/new", type: :view do
  before(:each) do
    assign(:fee_schedule, FeeSchedule.new())
  end

  it "renders new fee_schedule form" do
    render

    assert_select "form[action=?][method=?]", fee_schedules_path, "post" do
    end
  end
end
