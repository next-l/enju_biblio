require "spec_helper"

describe AgentRelationshipTypesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/agent_relationship_types" }.should route_to(:controller => "agent_relationship_types", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/agent_relationship_types/new" }.should route_to(:controller => "agent_relationship_types", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/agent_relationship_types/1" }.should route_to(:controller => "agent_relationship_types", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/agent_relationship_types/1/edit" }.should route_to(:controller => "agent_relationship_types", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/agent_relationship_types" }.should route_to(:controller => "agent_relationship_types", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/agent_relationship_types/1" }.should route_to(:controller => "agent_relationship_types", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/agent_relationship_types/1" }.should route_to(:controller => "agent_relationship_types", :action => "destroy", :id => "1")
    end

  end
end
