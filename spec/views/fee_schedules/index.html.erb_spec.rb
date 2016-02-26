require 'rails_helper'

RSpec.describe "fee_schedules/index", type: :view do
  before(:each) do
    assign(:fee_schedules, [
      FeeSchedule.create!(),
      FeeSchedule.create!()
    ])
  end

  it "renders a list of fee_schedules" do
    render
  end
end
