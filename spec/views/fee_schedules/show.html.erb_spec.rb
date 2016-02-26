require 'rails_helper'

RSpec.describe "fee_schedules/show", type: :view do
  before(:each) do
    @fee_schedule = assign(:fee_schedule, FeeSchedule.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
