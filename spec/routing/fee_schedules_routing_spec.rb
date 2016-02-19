require "rails_helper"

RSpec.describe FeeSchedulesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fee_schedules").to route_to("fee_schedules#index")
    end

    it "routes to #new" do
      expect(:get => "/fee_schedules/new").to route_to("fee_schedules#new")
    end

    it "routes to #show" do
      expect(:get => "/fee_schedules/1").to route_to("fee_schedules#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/fee_schedules/1/edit").to route_to("fee_schedules#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/fee_schedules").to route_to("fee_schedules#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/fee_schedules/1").to route_to("fee_schedules#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fee_schedules/1").to route_to("fee_schedules#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/fee_schedules/1").to route_to("fee_schedules#destroy", :id => "1")
    end

  end
end
