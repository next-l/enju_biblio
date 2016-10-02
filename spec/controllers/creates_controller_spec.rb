require 'rails_helper'
require 'sunspot/rails/spec_helper'

describe CreatesController do
  fixtures :all
  disconnect_sunspot

  def valid_attributes
    FactoryGirl.attributes_for(:create)
  end

  describe "GET index" do
    before(:each) do
      FactoryGirl.create(:create)
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns all creates as @creates" do
        get :index
        expect(assigns(:creates)).to eq(Create.page(1))
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns all creates as @creates" do
        get :index
        expect(assigns(:creates)).to eq(Create.page(1))
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns all creates as @creates" do
        get :index
        expect(assigns(:creates)).to eq(Create.page(1))
      end
    end

    describe "When not logged in" do
      it "assigns all creates as @creates" do
        get :index
        expect(assigns(:creates)).to eq(Create.page(1))
      end
    end
  end

  describe "GET show" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested create as @create" do
        create = FactoryGirl.create(:create)
        get :show, :id => create.id
        expect(assigns(:create)).to eq(create)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested create as @create" do
        create = FactoryGirl.create(:create)
        get :show, :id => create.id
        expect(assigns(:create)).to eq(create)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns the requested create as @create" do
        create = FactoryGirl.create(:create)
        get :show, :id => create.id
        expect(assigns(:create)).to eq(create)
      end
    end

    describe "When not logged in" do
      it "assigns the requested create as @create" do
        create = FactoryGirl.create(:create)
        get :show, :id => create.id
        expect(assigns(:create)).to eq(create)
      end
    end
  end

  describe "GET new" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested create as @create" do
        get :new
        expect(assigns(:create)).not_to be_valid
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested create as @create" do
        get :new
        expect(assigns(:create)).not_to be_valid
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should not assign the requested create as @create" do
        get :new
        expect(assigns(:create)).to be_nil
        expect(response).to be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested create as @create" do
        get :new
        expect(assigns(:create)).to be_nil
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET edit" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested create as @create" do
        create = FactoryGirl.create(:create)
        get :edit, :id => create.id
        expect(assigns(:create)).to eq(create)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested create as @create" do
        create = FactoryGirl.create(:create)
        get :edit, :id => create.id
        expect(assigns(:create)).to eq(create)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns the requested create as @create" do
        create = FactoryGirl.create(:create)
        get :edit, :id => create.id
        expect(response).to be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested create as @create" do
        create = FactoryGirl.create(:create)
        get :edit, :id => create.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    before(:each) do
      @attrs = valid_attributes
      @invalid_attrs = {:work_id => ''}
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      describe "with valid params" do
        it "assigns a newly created create as @create" do
          post :create, :create => @attrs
          expect(assigns(:create)).to be_valid
        end

        it "redirects to the created create" do
          post :create, :create => @attrs
          expect(response).to redirect_to(create_url(assigns(:create)))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved create as @create" do
          post :create, :create => @invalid_attrs
          expect(assigns(:create)).not_to be_valid
        end

        it "re-renders the 'new' template" do
          post :create, :create => @invalid_attrs
          expect(response).to render_template("new")
        end
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      describe "with valid params" do
        it "assigns a newly created create as @create" do
          post :create, :create => @attrs
          expect(assigns(:create)).to be_valid
        end

        it "redirects to the created create" do
          post :create, :create => @attrs
          expect(response).to redirect_to(create_url(assigns(:create)))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved create as @create" do
          post :create, :create => @invalid_attrs
          expect(assigns(:create)).not_to be_valid
        end

        it "re-renders the 'new' template" do
          post :create, :create => @invalid_attrs
          expect(response).to render_template("new")
        end
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      describe "with valid params" do
        it "assigns a newly created create as @create" do
          post :create, :create => @attrs
          expect(assigns(:create)).to be_nil
        end

        it "should be forbidden" do
          post :create, :create => @attrs
          expect(response).to be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved create as @create" do
          post :create, :create => @invalid_attrs
          expect(assigns(:create)).to be_nil
        end

        it "should be forbidden" do
          post :create, :create => @invalid_attrs
          expect(response).to be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "assigns a newly created create as @create" do
          post :create, :create => @attrs
          expect(assigns(:create)).to be_nil
        end

        it "should be forbidden" do
          post :create, :create => @attrs
          expect(response).to redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved create as @create" do
          post :create, :create => @invalid_attrs
          expect(assigns(:create)).to be_nil
        end

        it "should be redirected to new session url" do
          post :create, :create => @invalid_attrs
          expect(response).to redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @create = creates(:create_00001)
      @attrs = valid_attributes
      @invalid_attrs = {:work_id => ''}
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      describe "with valid params" do
        it "updates the requested create" do
          put :update, :id => @create.id, :create => @attrs
        end

        it "assigns the requested create as @create" do
          put :update, :id => @create.id, :create => @attrs
          expect(assigns(:create)).to eq(@create)
        end
      end

      describe "with invalid params" do
        it "assigns the requested create as @create" do
          put :update, :id => @create.id, :create => @invalid_attrs
          expect(response).to render_template("edit")
        end
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      describe "with valid params" do
        it "updates the requested create" do
          put :update, :id => @create.id, :create => @attrs
        end

        it "assigns the requested create as @create" do
          put :update, :id => @create.id, :create => @attrs
          expect(assigns(:create)).to eq(@create)
          expect(response).to redirect_to(@create)
        end

        it "moves its position when specified" do
          position = @create.position
          put :update, :id => @create.id, :work_id => @create.work.id, :move => 'lower'
          expect(response).to redirect_to creates_url(work_id: @create.work_id)
          assigns(:create).reload.position.should eq position + 1
        end
      end

      describe "with invalid params" do
        it "assigns the create as @create" do
          put :update, :id => @create, :create => @invalid_attrs
          expect(assigns(:create)).not_to be_valid
        end

        it "re-renders the 'edit' template" do
          put :update, :id => @create, :create => @invalid_attrs
          expect(response).to render_template("edit")
        end
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      describe "with valid params" do
        it "updates the requested create" do
          put :update, :id => @create.id, :create => @attrs
        end

        it "assigns the requested create as @create" do
          put :update, :id => @create.id, :create => @attrs
          expect(assigns(:create)).to eq(@create)
          expect(response).to be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns the requested create as @create" do
          put :update, :id => @create.id, :create => @invalid_attrs
          expect(response).to be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "updates the requested create" do
          put :update, :id => @create.id, :create => @attrs
        end

        it "should be forbidden" do
          put :update, :id => @create.id, :create => @attrs
          expect(response).to redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns the requested create as @create" do
          put :update, :id => @create.id, :create => @invalid_attrs
          expect(response).to redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @create = FactoryGirl.create(:create)
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "destroys the requested create" do
        delete :destroy, :id => @create.id
      end

      it "redirects to the creates list" do
        delete :destroy, :id => @create.id
        expect(response).to redirect_to(creates_url)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "destroys the requested create" do
        delete :destroy, :id => @create.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @create.id
        expect(response).to redirect_to(creates_url)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "destroys the requested create" do
        delete :destroy, :id => @create.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @create.id
        expect(response).to be_forbidden
      end
    end

    describe "When not logged in" do
      it "destroys the requested create" do
        delete :destroy, :id => @create.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @create.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
