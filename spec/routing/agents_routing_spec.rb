require "spec_helper"

describe AgentsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/agents" }.should route_to(:controller => "agents", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/agents/new" }.should route_to(:controller => "agents", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/agents/1" }.should route_to(:controller => "agents", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/agents/1/edit" }.should route_to(:controller => "agents", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/agents" }.should route_to(:controller => "agents", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/agents/1" }.should route_to(:controller => "agents", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/agents/1" }.should route_to(:controller => "agents", :action => "destroy", :id => "1")
    end

  end
end
