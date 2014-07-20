require "spec_helper"

describe AgentRelationshipsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/agent_relationships" }.should route_to(:controller => "agent_relationships", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/agent_relationships/new" }.should route_to(:controller => "agent_relationships", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/agent_relationships/1" }.should route_to(:controller => "agent_relationships", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/agent_relationships/1/edit" }.should route_to(:controller => "agent_relationships", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/agent_relationships" }.should route_to(:controller => "agent_relationships", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/agent_relationships/1" }.should route_to(:controller => "agent_relationships", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/agent_relationships/1" }.should route_to(:controller => "agent_relationships", :action => "destroy", :id => "1")
    end

  end
end
