require 'rails_helper'

RSpec.describe "CustomItemLabels", type: :request do
  describe "GET /custom_item_labels" do
    it "works! (now write some real specs)" do
      get custom_item_labels_path
      expect(response).to have_http_status(200)
    end
  end
end
