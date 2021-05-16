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

RSpec.describe "/periodicals", type: :request do
  # Periodical. As you add validations to Periodical, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Periodical.create! valid_attributes
      get periodicals_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      periodical = Periodical.create! valid_attributes
      get periodical_url(periodical)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_periodical_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      periodical = Periodical.create! valid_attributes
      get edit_periodical_url(periodical)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Periodical" do
        expect {
          post periodicals_url, params: { periodical: valid_attributes }
        }.to change(Periodical, :count).by(1)
      end

      it "redirects to the created periodical" do
        post periodicals_url, params: { periodical: valid_attributes }
        expect(response).to redirect_to(periodical_url(Periodical.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Periodical" do
        expect {
          post periodicals_url, params: { periodical: invalid_attributes }
        }.to change(Periodical, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post periodicals_url, params: { periodical: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested periodical" do
        periodical = Periodical.create! valid_attributes
        patch periodical_url(periodical), params: { periodical: new_attributes }
        periodical.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the periodical" do
        periodical = Periodical.create! valid_attributes
        patch periodical_url(periodical), params: { periodical: new_attributes }
        periodical.reload
        expect(response).to redirect_to(periodical_url(periodical))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        periodical = Periodical.create! valid_attributes
        patch periodical_url(periodical), params: { periodical: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested periodical" do
      periodical = Periodical.create! valid_attributes
      expect {
        delete periodical_url(periodical)
      }.to change(Periodical, :count).by(-1)
    end

    it "redirects to the periodicals list" do
      periodical = Periodical.create! valid_attributes
      delete periodical_url(periodical)
      expect(response).to redirect_to(periodicals_url)
    end
  end
end
