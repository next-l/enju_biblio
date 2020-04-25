require "rails_helper"

RSpec.describe ItemCustomPropertiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/item_custom_properties").to route_to("item_custom_properties#index")
    end

    it "routes to #new" do
      expect(get: "/item_custom_properties/new").to route_to("item_custom_properties#new")
    end

    it "routes to #show" do
      expect(get: "/item_custom_properties/1").to route_to("item_custom_properties#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/item_custom_properties/1/edit").to route_to("item_custom_properties#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/item_custom_properties").to route_to("item_custom_properties#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/item_custom_properties/1").to route_to("item_custom_properties#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/item_custom_properties/1").to route_to("item_custom_properties#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/item_custom_properties/1").to route_to("item_custom_properties#destroy", id: "1")
    end
  end
end
