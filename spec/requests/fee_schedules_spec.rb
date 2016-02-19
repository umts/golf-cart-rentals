require 'rails_helper'

RSpec.describe "FeeSchedules", type: :request do
  describe "GET /fee_schedules" do
    it "works! (now write some real specs)" do
      get fee_schedules_path
      expect(response).to have_http_status(200)
    end
  end
end
