require 'rails_helper'

RSpec.describe "fee_schedules/show", type: :view do
  before(:each) do
    @fee_schedule = assign(:fee_schedule, FeeSchedule.create!(
      :base_amount => "",
      :amount_per_day => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
