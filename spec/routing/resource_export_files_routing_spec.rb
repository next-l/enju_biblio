require 'rails_helper'

describe ResourceExportFilesController do
  describe "routing" do

    it "routes to #index" do
      get("/resource_export_files").should route_to("resource_export_files#index")
    end

    it "routes to #new" do
      get("/resource_export_files/new").should route_to("resource_export_files#new")
    end

    it "routes to #show" do
      get("/resource_export_files/1").should route_to("resource_export_files#show", :id => "1")
    end

    it "routes to #edit" do
      get("/resource_export_files/1/edit").should route_to("resource_export_files#edit", :id => "1")
    end

    it "routes to #create" do
      post("/resource_export_files").should route_to("resource_export_files#create")
    end

    it "routes to #update" do
      put("/resource_export_files/1").should route_to("resource_export_files#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/resource_export_files/1").should route_to("resource_export_files#destroy", :id => "1")
    end

  end
end
