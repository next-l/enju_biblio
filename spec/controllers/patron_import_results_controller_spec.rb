# -*- encoding: utf-8 -*-
require 'spec_helper'

describe PatronImportResultsController do
  fixtures :all

  describe "GET index" do
    describe "When logged in as Administrator" do
      before(:each) do
        sign_in FactoryGirl.create(:admin)
      end

      it "assigns all patron_import_results as @patron_import_results" do
        get :index
        assigns(:patron_import_results).should eq(PatronImportResult.page(1))
      end
    end

    describe "When logged in as Librarian" do
      before(:each) do
        sign_in FactoryGirl.create(:librarian)
      end

      it "assigns all patron_import_results as @patron_import_results" do
        get :index
        assigns(:patron_import_results).should eq(PatronImportResult.page(1))
      end
    end

    describe "When logged in as User" do
      before(:each) do
        sign_in FactoryGirl.create(:user)
      end

      it "assigns empty as @patron_import_results" do
        get :index
        assigns(:patron_import_results).should be_empty
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "assigns empty as @patron_import_results" do
        get :index
        assigns(:patron_import_results).should be_empty
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET show" do
    describe "When logged in as Administrator" do
      before(:each) do
        sign_in FactoryGirl.create(:admin)
      end

      it "assigns the requested patron_import_result as @patron_import_result" do
        get :show, :id => 1
        assigns(:patron_import_result).should eq(PatronImportResult.find(1))
      end
    end

    describe "When logged in as Librarian" do
      before(:each) do
        sign_in FactoryGirl.create(:librarian)
      end

      it "assigns the requested patron_import_result as @patron_import_result" do
        get :show, :id => 1
        assigns(:patron_import_result).should eq(PatronImportResult.find(1))
      end
    end

    describe "When logged in as User" do
      before(:each) do
        sign_in FactoryGirl.create(:user)
      end

      it "assigns the requested patron_import_result as @patron_import_result" do
        get :show, :id => 1
        assigns(:patron_import_result).should eq(PatronImportResult.find(1))
      end
    end

    describe "When not logged in" do
      it "assigns the requested patron_import_result as @patron_import_result" do
        get :show, :id => 1
        assigns(:patron_import_result).should eq(PatronImportResult.find(1))
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
