require 'spec_helper'

describe AgentRelationshipTypesController do
  fixtures :all

  def valid_attributes
    FactoryGirl.attributes_for(:agent_relationship_type)
  end

  describe "GET index" do
    before(:each) do
      FactoryGirl.create(:agent_relationship_type)
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns all agent_relationship_types as @agent_relationship_types" do
        get :index
        expect(assigns(:agent_relationship_types)).to eq(AgentRelationshipType.order(:position))
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns all agent_relationship_types as @agent_relationship_types" do
        get :index
        expect(assigns(:agent_relationship_types)).to eq(AgentRelationshipType.order(:position))
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns all agent_relationship_types as @agent_relationship_types" do
        get :index
        expect(assigns(:agent_relationship_types)).to eq(AgentRelationshipType.order(:position))
      end
    end

    describe "When not logged in" do
      it "assigns all agent_relationship_types as @agent_relationship_types" do
        get :index
        expect(assigns(:agent_relationship_types)).to eq(AgentRelationshipType.order(:position))
      end
    end
  end

  describe "GET show" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested agent_relationship_type as @agent_relationship_type" do
        agent_relationship_type = FactoryGirl.create(:agent_relationship_type)
        get :show, :id => agent_relationship_type.id
        expect(assigns(:agent_relationship_type)).to eq(agent_relationship_type)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested agent_relationship_type as @agent_relationship_type" do
        agent_relationship_type = FactoryGirl.create(:agent_relationship_type)
        get :show, :id => agent_relationship_type.id
        expect(assigns(:agent_relationship_type)).to eq(agent_relationship_type)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns the requested agent_relationship_type as @agent_relationship_type" do
        agent_relationship_type = FactoryGirl.create(:agent_relationship_type)
        get :show, :id => agent_relationship_type.id
        expect(assigns(:agent_relationship_type)).to eq(agent_relationship_type)
      end
    end

    describe "When not logged in" do
      it "assigns the requested agent_relationship_type as @agent_relationship_type" do
        agent_relationship_type = FactoryGirl.create(:agent_relationship_type)
        get :show, :id => agent_relationship_type.id
        expect(assigns(:agent_relationship_type)).to eq(agent_relationship_type)
      end
    end
  end

  describe "GET new" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested agent_relationship_type as @agent_relationship_type" do
        get :new
        expect(assigns(:agent_relationship_type)).not_to be_valid
        expect(response).to be_success
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "should not assign the requested agent_relationship_type as @agent_relationship_type" do
        get :new
        expect(assigns(:agent_relationship_type)).not_to be_valid
        expect(response).to be_forbidden
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should not assign the requested agent_relationship_type as @agent_relationship_type" do
        get :new
        expect(assigns(:agent_relationship_type)).not_to be_valid
        expect(response).to be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested agent_relationship_type as @agent_relationship_type" do
        get :new
        expect(assigns(:agent_relationship_type)).not_to be_valid
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET edit" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested agent_relationship_type as @agent_relationship_type" do
        agent_relationship_type = FactoryGirl.create(:agent_relationship_type)
        get :edit, :id => agent_relationship_type.id
        expect(assigns(:agent_relationship_type)).to eq(agent_relationship_type)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested agent_relationship_type as @agent_relationship_type" do
        agent_relationship_type = FactoryGirl.create(:agent_relationship_type)
        get :edit, :id => agent_relationship_type.id
        expect(response).to be_forbidden
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns the requested agent_relationship_type as @agent_relationship_type" do
        agent_relationship_type = FactoryGirl.create(:agent_relationship_type)
        get :edit, :id => agent_relationship_type.id
        expect(response).to be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested agent_relationship_type as @agent_relationship_type" do
        agent_relationship_type = FactoryGirl.create(:agent_relationship_type)
        get :edit, :id => agent_relationship_type.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    before(:each) do
      @attrs = valid_attributes
      @invalid_attrs = {:name => ''}
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      describe "with valid params" do
        it "assigns a newly created agent_relationship_type as @agent_relationship_type" do
          post :create, :agent_relationship_type => @attrs
          expect(assigns(:agent_relationship_type)).to be_valid
        end

        it "redirects to the created agent" do
          post :create, :agent_relationship_type => @attrs
          expect(response).to redirect_to(assigns(:agent_relationship_type))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved agent_relationship_type as @agent_relationship_type" do
          post :create, :agent_relationship_type => @invalid_attrs
          expect(assigns(:agent_relationship_type)).not_to be_valid
        end

        it "should be successful" do
          post :create, :agent_relationship_type => @invalid_attrs
          expect(response).to be_success
        end
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      describe "with valid params" do
        it "assigns a newly created agent_relationship_type as @agent_relationship_type" do
          post :create, :agent_relationship_type => @attrs
          expect(assigns(:agent_relationship_type)).to be_valid
        end

        it "should be forbidden" do
          post :create, :agent_relationship_type => @attrs
          expect(response).to be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved agent_relationship_type as @agent_relationship_type" do
          post :create, :agent_relationship_type => @invalid_attrs
          expect(assigns(:agent_relationship_type)).not_to be_valid
        end

        it "should be forbidden" do
          post :create, :agent_relationship_type => @invalid_attrs
          expect(response).to be_forbidden
        end
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      describe "with valid params" do
        it "assigns a newly created agent_relationship_type as @agent_relationship_type" do
          post :create, :agent_relationship_type => @attrs
          expect(assigns(:agent_relationship_type)).to be_valid
        end

        it "should be forbidden" do
          post :create, :agent_relationship_type => @attrs
          expect(response).to be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved agent_relationship_type as @agent_relationship_type" do
          post :create, :agent_relationship_type => @invalid_attrs
          expect(assigns(:agent_relationship_type)).not_to be_valid
        end

        it "should be forbidden" do
          post :create, :agent_relationship_type => @invalid_attrs
          expect(response).to be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "assigns a newly created agent_relationship_type as @agent_relationship_type" do
          post :create, :agent_relationship_type => @attrs
          expect(assigns(:agent_relationship_type)).to be_valid
        end

        it "should be forbidden" do
          post :create, :agent_relationship_type => @attrs
          expect(response).to redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved agent_relationship_type as @agent_relationship_type" do
          post :create, :agent_relationship_type => @invalid_attrs
          expect(assigns(:agent_relationship_type)).not_to be_valid
        end

        it "should be forbidden" do
          post :create, :agent_relationship_type => @invalid_attrs
          expect(response).to redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @agent_relationship_type = FactoryGirl.create(:agent_relationship_type)
      @attrs = valid_attributes
      @invalid_attrs = {:name => ''}
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      describe "with valid params" do
        it "updates the requested agent_relationship_type" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @attrs
        end

        it "assigns the requested agent_relationship_type as @agent_relationship_type" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @attrs
          expect(assigns(:agent_relationship_type)).to eq(@agent_relationship_type)
        end

        it "moves its position when specified" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @attrs, :move => 'lower'
          expect(response).to redirect_to(agent_relationship_types_url)
        end
      end

      describe "with invalid params" do
        it "assigns the requested agent_relationship_type as @agent_relationship_type" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @invalid_attrs
          expect(response).to render_template("edit")
        end
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      describe "with valid params" do
        it "updates the requested agent_relationship_type" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @attrs
        end

        it "assigns the requested agent_relationship_type as @agent_relationship_type" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @attrs
          expect(assigns(:agent_relationship_type)).to eq(@agent_relationship_type)
          expect(response).to be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns the requested agent_relationship_type as @agent_relationship_type" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @invalid_attrs
          expect(response).to be_forbidden
        end
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      describe "with valid params" do
        it "updates the requested agent_relationship_type" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @attrs
        end

        it "assigns the requested agent_relationship_type as @agent_relationship_type" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @attrs
          expect(assigns(:agent_relationship_type)).to eq(@agent_relationship_type)
          expect(response).to be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns the requested agent_relationship_type as @agent_relationship_type" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @invalid_attrs
          expect(response).to be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "updates the requested agent_relationship_type" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @attrs
        end

        it "should be forbidden" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @attrs
          expect(response).to redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns the requested agent_relationship_type as @agent_relationship_type" do
          put :update, :id => @agent_relationship_type.id, :agent_relationship_type => @invalid_attrs
          expect(response).to redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @agent_relationship_type = FactoryGirl.create(:agent_relationship_type)
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "destroys the requested agent_relationship_type" do
        delete :destroy, :id => @agent_relationship_type.id
      end

      it "redirects to the agent_relationship_types list" do
        delete :destroy, :id => @agent_relationship_type.id
        expect(response).to redirect_to(agent_relationship_types_url)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "destroys the requested agent_relationship_type" do
        delete :destroy, :id => @agent_relationship_type.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @agent_relationship_type.id
        expect(response).to be_forbidden
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "destroys the requested agent_relationship_type" do
        delete :destroy, :id => @agent_relationship_type.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @agent_relationship_type.id
        expect(response).to be_forbidden
      end
    end

    describe "When not logged in" do
      it "destroys the requested agent_relationship_type" do
        delete :destroy, :id => @agent_relationship_type.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @agent_relationship_type.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
