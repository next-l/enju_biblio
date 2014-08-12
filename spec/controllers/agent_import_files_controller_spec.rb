# -*- encoding: utf-8 -*-
require 'spec_helper'

describe AgentImportFilesController do
  fixtures :all

  describe "GET index" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns all agent_import_files as @agent_import_files" do
        get :index
        assigns(:agent_import_files).should eq(AgentImportFile.page(1))
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns all agent_import_files as @agent_import_files" do
        get :index
        assigns(:agent_import_files).should eq(AgentImportFile.page(1))
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns empty as @agent_import_files" do
        get :index
        assigns(:agent_import_files).should be_empty
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "assigns empty as @agent_import_files" do
        get :index
        assigns(:agent_import_files).should be_empty
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET show" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested agent_import_file as @agent_import_file" do
        get :show, :id => 1
        assigns(:agent_import_file).should eq(AgentImportFile.find(1))
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested agent_import_file as @agent_import_file" do
        get :show, :id => 1
        assigns(:agent_import_file).should eq(AgentImportFile.find(1))
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns the requested agent_import_file as @agent_import_file" do
        get :show, :id => 1
        assigns(:agent_import_file).should eq(AgentImportFile.find(1))
      end
    end

    describe "When not logged in" do
      it "assigns the requested agent_import_file as @agent_import_file" do
        get :show, :id => 1
        assigns(:agent_import_file).should eq(AgentImportFile.find(1))
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET new" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested agent_import_file as @agent_import_file" do
        get :new
        assigns(:agent_import_file).should_not be_valid
        response.should be_success
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "should not assign the requested agent_import_file as @agent_import_file" do
        get :new
        assigns(:agent_import_file).should_not be_valid
        response.should be_success
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should not assign the requested agent_import_file as @agent_import_file" do
        get :new
        assigns(:agent_import_file).should_not be_valid
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested agent_import_file as @agent_import_file" do
        get :new
        assigns(:agent_import_file).should_not be_valid
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "should create agent_import_file" do
        post :create, :agent_import_file => {:agent_import => fixture_file_upload("/../../examples/agent_import_file_sample1.tsv", 'text/csv') }
        assigns(:agent_import_file).should be_valid
        assigns(:agent_import_file).user.username.should eq @user.username
        response.should redirect_to agent_import_file_url(assigns(:agent_import_file))
      end

      it "should import user" do
        old_agents_count = Agent.count
        post :create, :agent_import_file => {:agent_import => fixture_file_upload("/../../examples/agent_import_file_sample2.tsv", 'text/csv') }
        assigns(:agent_import_file).import_start
        Agent.count.should eq old_agents_count + 6
        response.should redirect_to agent_import_file_url(assigns(:agent_import_file))
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should be forbidden" do
        post :create, :agent_import_file => {:agent_import => fixture_file_upload("/../..//examples/agent_import_file_sample1.tsv", 'text/csv') }
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should be redirect to new session url" do
        post :create, :agent_import_file => {:agent_import => fixture_file_upload("/../../examples/agent_import_file_sample1.tsv", 'text/csv') }
        response.should redirect_to new_user_session_url
      end
    end
  end

  describe "GET edit" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested agent_import_file as @agent_import_file" do
        agent_import_file = agent_import_files(:agent_import_file_00001)
        get :edit, :id => agent_import_file.id
        assigns(:agent_import_file).should eq(agent_import_file)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested agent_import_file as @agent_import_file" do
        agent_import_file = agent_import_files(:agent_import_file_00001)
        get :edit, :id => agent_import_file.id
        assigns(:agent_import_file).should eq(agent_import_file)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns the requested agent_import_file as @agent_import_file" do
        agent_import_file = agent_import_files(:agent_import_file_00001)
        get :edit, :id => agent_import_file.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested agent_import_file as @agent_import_file" do
        agent_import_file = agent_import_files(:agent_import_file_00001)
        get :edit, :id => agent_import_file.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "PUT update" do
    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "should update agent_import_file" do
        put :update, :id => agent_import_files(:agent_import_file_00003).id, :agent_import_file => { }
        response.should redirect_to agent_import_file_url(assigns(:agent_import_file))
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should not update agent_import_file" do
        put :update, :id => agent_import_files(:agent_import_file_00003).id, :agent_import_file => { }
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not update agent_import_file" do
        put :update, :id => agent_import_files(:agent_import_file_00003).id, :agent_import_file => { }
        response.should redirect_to new_user_session_url
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @agent_import_file = agent_import_files(:agent_import_file_00001)
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "destroys the requested agent_import_file" do
        delete :destroy, :id => @agent_import_file.id
      end

      it "redirects to the agent_import_files list" do
        delete :destroy, :id => @agent_import_file.id
        response.should redirect_to(agent_import_files_url)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "destroys the requested agent_import_file" do
        delete :destroy, :id => @agent_import_file.id
      end

      it "redirects to the agent_import_files list" do
        delete :destroy, :id => @agent_import_file.id
        response.should redirect_to(agent_import_files_url)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "destroys the requested agent_import_file" do
        delete :destroy, :id => @agent_import_file.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @agent_import_file.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "destroys the requested agent_import_file" do
        delete :destroy, :id => @agent_import_file.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @agent_import_file.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
