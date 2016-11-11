# -*- encoding: utf-8 -*-
require 'rails_helper'

describe "import_requests/index" do
  fixtures :users

  before(:each) do
    assign(:import_requests, Kaminari::paginate_array([
      stub_model(ImportRequest,
        :id => 1,
        :isbn => "1111111111",
        :created_at => Time.zone.now,
        :user_id => 1
      ),
      stub_model(ImportRequest,
        :id => 2,
        :isbn => "1111111112",
        :created_at => Time.zone.now,
        :user_id => 2
      )
    ]).page(1))
  end

  it "renders a list of import_requests" do
    allow(view).to receive(:policy).and_return double(create?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(1)", :text => "1"
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(2)", /enjuadmin1111111111/
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(3)", :text => localized_state('pending')
  end
end
