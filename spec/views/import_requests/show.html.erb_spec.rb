require 'rails_helper'

describe "import_requests/show" do
  before(:each) do
    @import_request = assign(:import_request, stub_model(ImportRequest,
      isbn: "1111111111",
      created_at: Time.zone.now
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Id/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/ISBN/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(localized_state('pending'))
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
