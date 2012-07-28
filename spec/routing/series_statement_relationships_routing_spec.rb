require "spec_helper"

describe SeriesStatementRelationshipsController do
  describe "routing" do

    it "routes to #index" do
      get("/series_statement_relationships").should route_to("series_statement_relationships#index")
    end

    it "routes to #new" do
      get("/series_statement_relationships/new").should route_to("series_statement_relationships#new")
    end

    it "routes to #show" do
      get("/series_statement_relationships/1").should route_to("series_statement_relationships#show", :id => "1")
    end

    it "routes to #edit" do
      get("/series_statement_relationships/1/edit").should route_to("series_statement_relationships#edit", :id => "1")
    end

    it "routes to #create" do
      post("/series_statement_relationships").should route_to("series_statement_relationships#create")
    end

    it "routes to #update" do
      put("/series_statement_relationships/1").should route_to("series_statement_relationships#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/series_statement_relationships/1").should route_to("series_statement_relationships#destroy", :id => "1")
    end

  end
end
