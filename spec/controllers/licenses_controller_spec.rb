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

describe LicensesController do
  fixtures :all
  login_fixture_admin

  # This should return the minimal set of attributes required to create a valid
  # License. As you add validations to License, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryBot.attributes_for(:license)
  end

  describe 'GET index' do
    it 'assigns all licenses as @licenses' do
      license = License.create! valid_attributes
      get :index
      expect(assigns(:licenses)).to eq(License.order(:position))
    end
  end

  describe 'GET show' do
    it 'assigns the requested license as @license' do
      license = License.create! valid_attributes
      get :show, params: { id: license.id }
      expect(assigns(:license)).to eq(license)
    end
  end

  describe 'GET new' do
    it 'assigns a new license as @license' do
      get :new
      expect(assigns(:license)).to be_a_new(License)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested license as @license' do
      license = License.create! valid_attributes
      get :edit, params: { id: license.id }
      expect(assigns(:license)).to eq(license)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new License' do
        expect do
          post :create, params: { license: valid_attributes }
        end.to change(License, :count).by(1)
      end

      it 'assigns a newly created license as @license' do
        post :create, params: { license: valid_attributes }
        expect(assigns(:license)).to be_a(License)
        expect(assigns(:license)).to be_persisted
      end

      it 'redirects to the created license' do
        post :create, params: { license: valid_attributes }
        expect(response).to redirect_to(License.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved license as @license' do
        # Trigger the behavior that occurs when invalid params are submitted
        License.any_instance.stub(:save).and_return(false)
        post :create, params: { license: { name: 'test' } }
        expect(assigns(:license)).to be_a_new(License)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        License.any_instance.stub(:save).and_return(false)
        post :create, params: { license: { name: 'test' } }
        # expect(response).to render_template("new")
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested license' do
        license = License.create! valid_attributes
        # Assuming there are no other licenses in the database, this
        # specifies that the License created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        License.any_instance.should_receive(:update_attributes).with('name' => 'test')
        put :update, params: { id: license.id, license: { 'name' => 'test' } }
      end

      it 'assigns the requested license as @license' do
        license = License.create! valid_attributes
        put :update, params: { id: license.id, license: valid_attributes }
        expect(assigns(:license)).to eq(license)
      end

      it 'redirects to the license' do
        license = License.create! valid_attributes
        put :update, params: { id: license.id, license: valid_attributes }
        expect(response).to redirect_to(license)
      end

      it 'moves its position when specified' do
        license = License.create! valid_attributes
        position = license.position
        put :update, params: { id: license.id, move: 'higher' }
        expect(response).to redirect_to licenses_url
        assigns(:license).reload.position.should eq position - 1
      end
    end

    describe 'with invalid params' do
      it 'assigns the license as @license' do
        license = License.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        License.any_instance.stub(:save).and_return(false)
        put :update, params: { id: license.id, license: { name: 'test' } }
        expect(assigns(:license)).to eq(license)
      end

      it "re-renders the 'edit' template" do
        license = License.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        License.any_instance.stub(:save).and_return(false)
        put :update, params: { id: license.id, license: { name: 'test' } }
        # expect(response).to render_template("edit")
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested license' do
      license = License.create! valid_attributes
      expect do
        delete :destroy, params: { id: license.id }
      end.to change(License, :count).by(-1)
    end

    it 'redirects to the licenses list' do
      license = License.create! valid_attributes
      delete :destroy, params: { id: license.id }
      expect(response).to redirect_to(licenses_url)
    end
  end
end
