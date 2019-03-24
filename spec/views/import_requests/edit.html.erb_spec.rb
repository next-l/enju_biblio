require 'rails_helper'

describe "import_requests/edit" do
  before(:each) do
    @import_request = assign(:import_request, stub_model(ImportRequest,
      id: '659f2004-b1a7-48b0-840a-d6e928f1e236',
      isbn: "1111111111",
      created_at: Time.zone.now
    ))
  end

  it "renders the edit import_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: import_requests_path(@import_request), method: "post" do
      assert_select "input#import_request_isbn", name: "import_request[isbn]"
    end
  end
end
