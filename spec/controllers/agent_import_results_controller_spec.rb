# -*- encoding: utf-8 -*-
require 'spec_helper'

describe AgentImportResultsController do
  fixtures :all

  describe "GET index" do
    describe "When logged in as Administrator" do
      before(:each) do
        sign_in FactoryGirl.create(:admin)
      end

      it "assigns all agent_import_results as @agent_import_results" do
        get :index
        assigns(:agent_import_results).should eq(AgentImportResult.page(1))
      end
    end

    describe "When logged in as Librarian" do
      before(:each) do
        sign_in FactoryGirl.create(:librarian)
      end

      it "assigns all agent_import_results as @agent_import_results" do
        get :index
        assigns(:agent_import_results).should eq(AgentImportResult.page(1))
      end
    end

    describe "When logged in as User" do
      before(:each) do
        sign_in FactoryGirl.create(:user)
      end

      it "assigns empty as @agent_import_results" do
        get :index
        assigns(:agent_import_results).should be_empty
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "assigns empty as @agent_import_results" do
        get :index
        assigns(:agent_import_results).should be_empty
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET show" do
    describe "When logged in as Administrator" do
      before(:each) do
        sign_in FactoryGirl.create(:admin)
      end

      it "assigns the requested agent_import_result as @agent_import_result" do
        get :show, :id => 1
        assigns(:agent_import_result).should eq(AgentImportResult.find(1))
      end
    end

    describe "When logged in as Librarian" do
      before(:each) do
        sign_in FactoryGirl.create(:librarian)
      end

      it "assigns the requested agent_import_result as @agent_import_result" do
        get :show, :id => 1
        assigns(:agent_import_result).should eq(AgentImportResult.find(1))
      end
    end

    describe "When logged in as User" do
      before(:each) do
        sign_in FactoryGirl.create(:user)
      end

      it "assigns the requested agent_import_result as @agent_import_result" do
        get :show, :id => 1
        assigns(:agent_import_result).should eq(AgentImportResult.find(1))
      end
    end

    describe "When not logged in" do
      it "assigns the requested agent_import_result as @agent_import_result" do
        get :show, :id => 1
        assigns(:agent_import_result).should eq(AgentImportResult.find(1))
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
