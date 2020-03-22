require 'rails_helper'

RSpec.describe "CustomManifestationLabels", type: :request do
  describe "GET /custom_manifestation_labels" do
    it "works! (now write some real specs)" do
      get custom_manifestation_labels_path
      expect(response).to have_http_status(200)
    end
  end
end
