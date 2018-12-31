require 'rails_helper'

describe "import_requests/new" do
  before(:each) do
    assign(:import_request, stub_model(ImportRequest,
      name: "MyString",
      display_name: "MyText",
      note: "MyText",
      position: 1
    ).as_new_record)
  end

  it "renders new import_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: import_requests_path, method: "post" do
      assert_select "input#import_request_isbn", name: "import_request[isbn]"
    end
  end
end
