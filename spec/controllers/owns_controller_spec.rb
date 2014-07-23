require 'spec_helper'

describe OwnsController do
  fixtures :all

  def valid_attributes
    FactoryGirl.attributes_for(:own)
  end

  describe "GET index" do
    before(:each) do
      FactoryGirl.create(:own)
    end

    describe "When logged in as Administrator" do
      login_admin

      it "assigns all owns as @owns" do
        get :index
        assigns(:owns).should eq(Own.page(1))
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns all owns as @owns" do
        get :index
        assigns(:owns).should eq(Own.page(1))
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns all owns as @owns" do
        get :index
        assigns(:owns).should eq(Own.page(1))
      end
    end

    describe "When not logged in" do
      it "assigns all owns as @owns" do
        get :index
        assigns(:owns).should eq(Own.page(1))
      end
    end
  end

  describe "GET show" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested own as @own" do
        own = FactoryGirl.create(:own)
        get :show, :id => own.id
        assigns(:own).should eq(own)
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns the requested own as @own" do
        own = FactoryGirl.create(:own)
        get :show, :id => own.id
        assigns(:own).should eq(own)
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns the requested own as @own" do
        own = FactoryGirl.create(:own)
        get :show, :id => own.id
        assigns(:own).should eq(own)
      end
    end

    describe "When not logged in" do
      it "assigns the requested own as @own" do
        own = FactoryGirl.create(:own)
        get :show, :id => own.id
        assigns(:own).should eq(own)
      end
    end
  end

  describe "GET new" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested own as @own" do
        get :new
        assigns(:own).should_not be_valid
        response.should be_success
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns the requested own as @own" do
        get :new
        assigns(:own).should_not be_valid
        response.should be_success
      end
    end

    describe "When logged in as User" do
      login_user

      it "should not assign the requested own as @own" do
        get :new
        assigns(:own).should_not be_valid
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested own as @own" do
        get :new
        assigns(:own).should_not be_valid
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET edit" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested own as @own" do
        own = FactoryGirl.create(:own)
        get :edit, :id => own.id
        assigns(:own).should eq(own)
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns the requested own as @own" do
        own = FactoryGirl.create(:own)
        get :edit, :id => own.id
        assigns(:own).should eq(own)
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns the requested own as @own" do
        own = FactoryGirl.create(:own)
        get :edit, :id => own.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested own as @own" do
        own = FactoryGirl.create(:own)
        get :edit, :id => own.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    before(:each) do
      @attrs = valid_attributes
      @invalid_attrs = {:item_id => ''}
    end

    describe "When logged in as Administrator" do
      login_admin

      describe "with valid params" do
        it "assigns a newly created own as @own" do
          post :create, :own => @attrs
          assigns(:own).should be_valid
        end

        it "redirects to the created agent" do
          post :create, :own => @attrs
          response.should redirect_to(assigns(:own))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved own as @own" do
          post :create, :own => @invalid_attrs
          assigns(:own).should_not be_valid
        end

        it "re-renders the 'new' template" do
          post :create, :own => @invalid_attrs
          response.should render_template("new")
        end
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      describe "with valid params" do
        it "assigns a newly created own as @own" do
          post :create, :own => @attrs
          assigns(:own).should be_valid
        end

        it "redirects to the created agent" do
          post :create, :own => @attrs
          response.should redirect_to(assigns(:own))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved own as @own" do
          post :create, :own => @invalid_attrs
          assigns(:own).should_not be_valid
        end

        it "re-renders the 'new' template" do
          post :create, :own => @invalid_attrs
          response.should render_template("new")
        end
      end
    end

    describe "When logged in as User" do
      login_user

      describe "with valid params" do
        it "assigns a newly created own as @own" do
          post :create, :own => @attrs
          assigns(:own).should be_valid
        end

        it "should be forbidden" do
          post :create, :own => @attrs
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved own as @own" do
          post :create, :own => @invalid_attrs
          assigns(:own).should_not be_valid
        end

        it "should be forbidden" do
          post :create, :own => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "assigns a newly created own as @own" do
          post :create, :own => @attrs
          assigns(:own).should be_valid
        end

        it "should be forbidden" do
          post :create, :own => @attrs
          response.should redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved own as @own" do
          post :create, :own => @invalid_attrs
          assigns(:own).should_not be_valid
        end

        it "should be forbidden" do
          post :create, :own => @invalid_attrs
          response.should redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @own = FactoryGirl.create(:own)
      @attrs = valid_attributes
      @invalid_attrs = {:item_id => ''}
    end

    describe "When logged in as Administrator" do
      login_admin

      describe "with valid params" do
        it "updates the requested own" do
          put :update, :id => @own.id, :own => @attrs
        end

        it "assigns the requested own as @own" do
          put :update, :id => @own.id, :own => @attrs
          assigns(:own).should eq(@own)
          response.should redirect_to(@own)
        end

        it "moves its position when specified" do
          put :update, :id => @own.id, :own => @attrs, :item_id => @own.item.id, :move => 'lower'
          response.should redirect_to(owns_url(item_id: @own.item_id))
        end
      end

      describe "with invalid params" do
        it "assigns the requested own as @own" do
          put :update, :id => @own.id, :own => @invalid_attrs
          response.should render_template("edit")
        end
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      describe "with valid params" do
        it "updates the requested own" do
          put :update, :id => @own.id, :own => @attrs
        end

        it "assigns the requested own as @own" do
          put :update, :id => @own.id, :own => @attrs
          assigns(:own).should eq(@own)
          response.should redirect_to(@own)
        end
      end

      describe "with invalid params" do
        it "assigns the requested own as @own" do
          put :update, :id => @own.id, :own => @invalid_attrs
          response.should render_template("edit")
        end
      end
    end

    describe "When logged in as User" do
      login_user

      describe "with valid params" do
        it "updates the requested own" do
          put :update, :id => @own.id, :own => @attrs
        end

        it "assigns the requested own as @own" do
          put :update, :id => @own.id, :own => @attrs
          assigns(:own).should eq(@own)
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns the requested own as @own" do
          put :update, :id => @own.id, :own => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "updates the requested own" do
          put :update, :id => @own.id, :own => @attrs
        end

        it "should be forbidden" do
          put :update, :id => @own.id, :own => @attrs
          response.should redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns the requested own as @own" do
          put :update, :id => @own.id, :own => @invalid_attrs
          response.should redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @own = FactoryGirl.create(:own)
    end

    describe "When logged in as Administrator" do
      login_admin

      it "destroys the requested own" do
        delete :destroy, :id => @own.id
      end

      it "redirects to the owns list" do
        delete :destroy, :id => @own.id
        response.should redirect_to(owns_url)
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "destroys the requested own" do
        delete :destroy, :id => @own.id
      end

      it "redirects to the owns list" do
        delete :destroy, :id => @own.id
        response.should redirect_to(owns_url)
      end
    end

    describe "When logged in as User" do
      login_user

      it "destroys the requested own" do
        delete :destroy, :id => @own.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @own.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "destroys the requested own" do
        delete :destroy, :id => @own.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @own.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
