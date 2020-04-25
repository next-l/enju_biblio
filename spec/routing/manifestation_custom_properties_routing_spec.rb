require "rails_helper"

RSpec.describe ManifestationCustomPropertiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/manifestation_custom_properties").to route_to("manifestation_custom_properties#index")
    end

    it "routes to #new" do
      expect(get: "/manifestation_custom_properties/new").to route_to("manifestation_custom_properties#new")
    end

    it "routes to #show" do
      expect(get: "/manifestation_custom_properties/1").to route_to("manifestation_custom_properties#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/manifestation_custom_properties/1/edit").to route_to("manifestation_custom_properties#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/manifestation_custom_properties").to route_to("manifestation_custom_properties#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/manifestation_custom_properties/1").to route_to("manifestation_custom_properties#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/manifestation_custom_properties/1").to route_to("manifestation_custom_properties#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/manifestation_custom_properties/1").to route_to("manifestation_custom_properties#destroy", id: "1")
    end
  end
end
