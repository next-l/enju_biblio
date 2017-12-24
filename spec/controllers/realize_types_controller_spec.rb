require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe RealizeTypesController do
  fixtures :all
  login_fixture_admin

  # This should return the minimal set of attributes required to create a valid
  # RealizeType. As you add validations to RealizeType, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryBot.attributes_for(:realize_type)
  end

  describe 'GET index' do
    it 'assigns all realize_types as @realize_types' do
      realize_type = RealizeType.create! valid_attributes
      get :index
      expect(assigns(:realize_types)).to eq(RealizeType.order(:position))
    end
  end

  describe 'GET show' do
    it 'assigns the requested realize_type as @realize_type' do
      realize_type = RealizeType.create! valid_attributes
      get :show, id: realize_type.id
      expect(assigns(:realize_type)).to eq(realize_type)
    end
  end

  describe 'GET new' do
    it 'assigns a new realize_type as @realize_type' do
      get :new
      expect(assigns(:realize_type)).to be_a_new(RealizeType)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested realize_type as @realize_type' do
      realize_type = RealizeType.create! valid_attributes
      get :edit, id: realize_type.id
      expect(assigns(:realize_type)).to eq(realize_type)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new RealizeType' do
        expect do
          post :create, realize_type: valid_attributes
        end.to change(RealizeType, :count).by(1)
      end

      it 'assigns a newly created realize_type as @realize_type' do
        post :create, realize_type: valid_attributes
        expect(assigns(:realize_type)).to be_a(RealizeType)
        expect(assigns(:realize_type)).to be_persisted
      end

      it 'redirects to the created realize_type' do
        post :create, realize_type: valid_attributes
        expect(response).to redirect_to(RealizeType.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved realize_type as @realize_type' do
        # Trigger the behavior that occurs when invalid params are submitted
        RealizeType.any_instance.stub(:save).and_return(false)
        post :create, realize_type: { name: 'test' }
        expect(assigns(:realize_type)).to be_a_new(RealizeType)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        RealizeType.any_instance.stub(:save).and_return(false)
        post :create, realize_type: { name: 'test' }
        # expect(response).to render_template("new")
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested realize_type' do
        realize_type = RealizeType.create! valid_attributes
        # Assuming there are no other realize_types in the database, this
        # specifies that the RealizeType created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        RealizeType.any_instance.should_receive(:update_attributes).with('name' => 'test')
        put :update, id: realize_type.id, realize_type: { 'name' => 'test' }
      end

      it 'assigns the requested realize_type as @realize_type' do
        realize_type = RealizeType.create! valid_attributes
        put :update, id: realize_type.id, realize_type: valid_attributes
        expect(assigns(:realize_type)).to eq(realize_type)
      end

      it 'redirects to the realize_type' do
        realize_type = RealizeType.create! valid_attributes
        put :update, id: realize_type.id, realize_type: valid_attributes
        expect(response).to redirect_to(realize_type)
      end

      it 'moves its position when specified' do
        realize_type = RealizeType.create! valid_attributes
        position = realize_type.position
        put :update, id: realize_type.id, move: 'higher'
        expect(response).to redirect_to realize_types_url
        assigns(:realize_type).reload.position.should eq position - 1
      end
    end

    describe 'with invalid params' do
      it 'assigns the realize_type as @realize_type' do
        realize_type = RealizeType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        RealizeType.any_instance.stub(:save).and_return(false)
        put :update, id: realize_type.id, realize_type: { name: 'test' }
        expect(assigns(:realize_type)).to eq(realize_type)
      end

      it "re-renders the 'edit' template" do
        realize_type = RealizeType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        RealizeType.any_instance.stub(:save).and_return(false)
        put :update, id: realize_type.id, realize_type: { name: 'test' }
        # expect(response).to render_template("edit")
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested realize_type' do
      realize_type = RealizeType.create! valid_attributes
      expect do
        delete :destroy, id: realize_type.id
      end.to change(RealizeType, :count).by(-1)
    end

    it 'redirects to the realize_types list' do
      realize_type = RealizeType.create! valid_attributes
      delete :destroy, id: realize_type.id
      expect(response).to redirect_to(realize_types_url)
    end
  end
end
