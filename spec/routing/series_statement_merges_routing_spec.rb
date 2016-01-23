# == Schema Information
#
# Table name: series_statement_merges
#
#  id                             :integer          not null, primary key
#  series_statement_id            :integer          not null
#  series_statement_merge_list_id :integer          not null
#  created_at                     :datetime
#  updated_at                     :datetime
#

require "spec_helper"

describe SeriesStatementMergesController do
  describe "routing" do

    it "routes to #index" do
      get("/series_statement_merges").should route_to("series_statement_merges#index")
    end

    it "routes to #new" do
      get("/series_statement_merges/new").should route_to("series_statement_merges#new")
    end

    it "routes to #show" do
      get("/series_statement_merges/1").should route_to("series_statement_merges#show", :id => "1")
    end

    it "routes to #edit" do
      get("/series_statement_merges/1/edit").should route_to("series_statement_merges#edit", :id => "1")
    end

    it "routes to #create" do
      post("/series_statement_merges").should route_to("series_statement_merges#create")
    end

    it "routes to #update" do
      put("/series_statement_merges/1").should route_to("series_statement_merges#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/series_statement_merges/1").should route_to("series_statement_merges#destroy", :id => "1")
    end

  end
end
