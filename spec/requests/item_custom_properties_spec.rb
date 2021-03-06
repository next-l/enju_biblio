 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/item_custom_properties", type: :request do
  # ItemCustomProperty. As you add validations to ItemCustomProperty, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryBot.attributes_for(:item_custom_property)
  }

  let(:invalid_attributes) {
    FactoryBot.attributes_for(:item_custom_property, name: nil)
  }

  describe "GET /index" do
    it "renders a successful response" do
      ItemCustomProperty.create! valid_attributes
      get item_custom_properties_url
      response.status.should redirect_to(new_user_session_url)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      item_custom_property = ItemCustomProperty.create! valid_attributes
      get item_custom_property_url(item_custom_property)
      expect(response).to redirect_to(new_user_session_url)
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_item_custom_property_url
      expect(response).to redirect_to(new_user_session_url)
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      item_custom_property = ItemCustomProperty.create! valid_attributes
      get edit_item_custom_property_url(item_custom_property)
      expect(response).to redirect_to(new_user_session_url)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new ItemCustomProperty" do
        expect {
          post item_custom_properties_url, params: { item_custom_property: valid_attributes }
        }.to change(ItemCustomProperty, :count).by(0)
      end

      it "redirects to the created item_custom_property" do
        post item_custom_properties_url, params: { item_custom_property: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context "with invalid parameters" do
      it "does not create a new ItemCustomProperty" do
        expect {
          post item_custom_properties_url, params: { item_custom_property: invalid_attributes }
        }.to change(ItemCustomProperty, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post item_custom_properties_url, params: { item_custom_property: invalid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested item_custom_property" do
        item_custom_property = ItemCustomProperty.create! valid_attributes
        patch item_custom_property_url(item_custom_property), params: { item_custom_property: new_attributes }
        item_custom_property.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the item_custom_property" do
        item_custom_property = ItemCustomProperty.create! valid_attributes
        patch item_custom_property_url(item_custom_property), params: { item_custom_property: new_attributes }
        item_custom_property.reload
        expect(response).to redirect_to(item_custom_property_url(item_custom_property))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        item_custom_property = ItemCustomProperty.create! valid_attributes
        patch item_custom_property_url(item_custom_property), params: { item_custom_property: invalid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested item_custom_property" do
      item_custom_property = ItemCustomProperty.create! valid_attributes
      expect {
        delete item_custom_property_url(item_custom_property)
      }.to change(ItemCustomProperty, :count).by(0)
    end

    it "redirects to the item_custom_properties list" do
      item_custom_property = ItemCustomProperty.create! valid_attributes
      delete item_custom_property_url(item_custom_property)
      expect(response).to redirect_to(new_user_session_url)
    end
  end
end
