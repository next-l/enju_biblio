require 'spec_helper'
require 'sunspot/rails/spec_helper'

describe IdentifiersController do
  fixtures :all
  disconnect_sunspot

  def valid_attributes
    @attrs = FactoryGirl.attributes_for(:identifier)
  end

  describe "GET index" do
    before(:each) do
      FactoryGirl.create(:identifier)
    end

    describe "When logged in as Administrator" do
      login_admin

      it "assigns all identifiers as @identifiers" do
        get :index
        assigns(:identifiers).should eq(Identifier.all)
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns all identifiers as @identifiers" do
        get :index
        assigns(:identifiers).should eq(Identifier.all)
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns all identifiers as @identifiers" do
        get :index
        assigns(:identifiers).should eq(Identifier.all)
      end
    end

    describe "When not logged in" do
      it "assigns all identifiers as @identifiers" do
        get :index
        assigns(:identifiers).should eq(Identifier.all)
      end
    end
  end

  describe "GET show" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested identifier as @identifier" do
        identifier = FactoryGirl.create(:identifier)
        get :show, :id => identifier.id
        assigns(:identifier).should eq(identifier)
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns the requested identifier as @identifier" do
        identifier = FactoryGirl.create(:identifier)
        get :show, :id => identifier.id
        assigns(:identifier).should eq(identifier)
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns the requested identifier as @identifier" do
        identifier = FactoryGirl.create(:identifier)
        get :show, :id => identifier.id
        assigns(:identifier).should eq(identifier)
      end
    end

    describe "When not logged in" do
      it "assigns the requested identifier as @identifier" do
        identifier = FactoryGirl.create(:identifier)
        get :show, :id => identifier.id
        assigns(:identifier).should eq(identifier)
      end
    end
  end

  describe "GET new" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested identifier as @identifier" do
        get :new
        assigns(:identifier).should_not be_valid
        response.should be_success
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "should not assign the requested identifier as @identifier" do
        get :new
        assigns(:identifier).should_not be_valid
        response.should be_success
      end
    end

    describe "When logged in as User" do
      login_user

      it "should not assign the requested identifier as @identifier" do
        get :new
        assigns(:identifier).should_not be_valid
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested identifier as @identifier" do
        get :new
        assigns(:identifier).should_not be_valid
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET edit" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested identifier as @identifier" do
        identifier = FactoryGirl.create(:identifier)
        get :edit, :id => identifier.id
        assigns(:identifier).should eq(identifier)
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns the requested identifier as @identifier" do
        identifier = FactoryGirl.create(:identifier)
        get :edit, :id => identifier.id
        assigns(:identifier).should eq(identifier)
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns the requested identifier as @identifier" do
        identifier = FactoryGirl.create(:identifier)
        get :edit, :id => identifier.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested identifier as @identifier" do
        identifier = FactoryGirl.create(:identifier)
        get :edit, :id => identifier.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    before(:each) do
      @attrs = valid_attributes
      @invalid_attrs = {:body => ''}
    end

    describe "When logged in as Administrator" do
      login_admin

      describe "with valid params" do
        it "assigns a newly created identifier as @identifier" do
          post :create, :identifier => @attrs
          assigns(:identifier).should be_valid
        end

        it "redirects to the created manifestation" do
          post :create, :identifier => @attrs
          response.should redirect_to(assigns(:identifier))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved identifier as @identifier" do
          post :create, :identifier => @invalid_attrs
          assigns(:identifier).should_not be_valid
        end

        it "re-renders the 'new' template" do
          post :create, :identifier => @invalid_attrs
          response.should render_template("new")
        end
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      describe "with valid params" do
        it "assigns a newly created identifier as @identifier" do
          post :create, :identifier => @attrs
          assigns(:identifier).should be_valid
        end

        it "redirects to the created manifestation" do
          post :create, :identifier => @attrs
          response.should redirect_to(assigns(:identifier))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved identifier as @identifier" do
          post :create, :identifier => @invalid_attrs
          assigns(:identifier).should_not be_valid
        end

        it "re-renders the 'new' template" do
          post :create, :identifier => @invalid_attrs
          response.should render_template("new")
        end
      end
    end

    describe "When logged in as User" do
      login_user

      describe "with valid params" do
        it "assigns a newly created identifier as @identifier" do
          post :create, :identifier => @attrs
          assigns(:identifier).should be_valid
        end

        it "should be forbidden" do
          post :create, :identifier => @attrs
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved identifier as @identifier" do
          post :create, :identifier => @invalid_attrs
          assigns(:identifier).should_not be_valid
        end

        it "should be forbidden" do
          post :create, :identifier => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "assigns a newly created identifier as @identifier" do
          post :create, :identifier => @attrs
          assigns(:identifier).should be_valid
        end

        it "should be forbidden" do
          post :create, :identifier => @attrs
          response.should redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved identifier as @identifier" do
          post :create, :identifier => @invalid_attrs
          assigns(:identifier).should_not be_valid
        end

        it "should be forbidden" do
          post :create, :identifier => @invalid_attrs
          response.should redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @identifier = FactoryGirl.create(:identifier)
      @attrs = valid_attributes
      @invalid_attrs = {:body => ''}
    end

    describe "When logged in as Administrator" do
      login_admin

      describe "with valid params" do
        it "updates the requested identifier" do
          put :update, :id => @identifier.id, :identifier => @attrs
        end

        it "assigns the requested identifier as @identifier" do
          put :update, :id => @identifier.id, :identifier => @attrs
          assigns(:identifier).should eq(@identifier)
          response.should redirect_to(@identifier)
        end

        it "moves its position when specified" do
          put :update, :id => @identifier.id, :identifier => @attrs, :move => 'lower'
          response.should redirect_to(identifiers_url)
        end
      end

      describe "with invalid params" do
        it "assigns the requested identifier as @identifier" do
          put :update, :id => @identifier.id, :identifier => @invalid_attrs
          response.should render_template("edit")
        end
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      describe "with valid params" do
        it "updates the requested identifier" do
          put :update, :id => @identifier.id, :identifier => @attrs
        end

        it "assigns the requested identifier as @identifier" do
          put :update, :id => @identifier.id, :identifier => @attrs
          assigns(:identifier).should eq(@identifier)
          response.should redirect_to(@identifier)
        end
      end

      describe "with invalid params" do
        it "assigns the requested identifier as @identifier" do
          put :update, :id => @identifier.id, :identifier => @invalid_attrs
          response.should render_template("edit")
        end
      end
    end

    describe "When logged in as User" do
      login_user

      describe "with valid params" do
        it "updates the requested identifier" do
          put :update, :id => @identifier.id, :identifier => @attrs
        end

        it "assigns the requested identifier as @identifier" do
          put :update, :id => @identifier.id, :identifier => @attrs
          assigns(:identifier).should eq(@identifier)
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns the requested identifier as @identifier" do
          put :update, :id => @identifier.id, :identifier => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "updates the requested identifier" do
          put :update, :id => @identifier.id, :identifier => @attrs
        end

        it "should be forbidden" do
          put :update, :id => @identifier.id, :identifier => @attrs
          response.should redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns the requested identifier as @identifier" do
          put :update, :id => @identifier.id, :identifier => @invalid_attrs
          response.should redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @identifier = FactoryGirl.create(:identifier)
    end

    describe "When logged in as Administrator" do
      login_admin

      it "destroys the requested identifier" do
        delete :destroy, :id => @identifier.id
      end

      it "redirects to the identifiers list" do
        delete :destroy, :id => @identifier.id
        response.should redirect_to(identifiers_url)
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "destroys the requested identifier" do
        delete :destroy, :id => @identifier.id
      end

      it "redirects to the identifiers list" do
        delete :destroy, :id => @identifier.id
        response.should redirect_to(identifiers_url)
      end
    end

    describe "When logged in as User" do
      login_user

      it "destroys the requested identifier" do
        delete :destroy, :id => @identifier.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @identifier.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "destroys the requested identifier" do
        delete :destroy, :id => @identifier.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @identifier.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
