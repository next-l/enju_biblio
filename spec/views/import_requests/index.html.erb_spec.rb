require 'rails_helper'

describe "import_requests/index" do
  fixtures :users

  before(:each) do
    assign(:import_requests, Kaminari.paginate_array([
      stub_model(ImportRequest,
        id: '659f2004-b1a7-48b0-840a-d6e928f1e236',
        isbn: "1111111111",
        created_at: Time.zone.now,
        user_id: 1
      ),
      stub_model(ImportRequest,
        id: '02ef8946-ca7f-4934-a224-ffabc30f2864',
        isbn: "1111111112",
        created_at: Time.zone.now,
        user_id: 2
      )
    ]).page(1))
  end

  it "renders a list of import_requests" do
    allow(view).to receive(:policy).and_return double(destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(1)", text: '659f2004-b1a7-48b0-840a-d6e928f1e236'
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(2)", /admin\n      1111111111\n/
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(3)", text: localized_state('pending')
  end
end
