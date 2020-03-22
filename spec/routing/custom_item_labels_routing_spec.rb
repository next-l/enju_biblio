require "rails_helper"

RSpec.describe CustomItemLabelsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/custom_item_labels").to route_to("custom_item_labels#index")
    end

    it "routes to #new" do
      expect(:get => "/custom_item_labels/new").to route_to("custom_item_labels#new")
    end

    it "routes to #show" do
      expect(:get => "/custom_item_labels/1").to route_to("custom_item_labels#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/custom_item_labels/1/edit").to route_to("custom_item_labels#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/custom_item_labels").to route_to("custom_item_labels#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/custom_item_labels/1").to route_to("custom_item_labels#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/custom_item_labels/1").to route_to("custom_item_labels#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/custom_item_labels/1").to route_to("custom_item_labels#destroy", :id => "1")
    end
  end
end
