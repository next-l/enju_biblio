require 'rails_helper'

describe "accepts/new" do
  fixtures :all

  before(:each) do
    assign(:accept, stub_model(Accept,
      item_id: FactoryBot.create(:item).id
    ).as_new_record)
    assign(:basket, FactoryBot.create(:basket))
    assign(:accepts, Kaminari::paginate_array([
      stub_model(Accept,
        item_id: FactoryBot.create(:item).id,
        created_at: Time.zone.now
      ),
      stub_model(Accept,
        item_id: FactoryBot.create(:item).id,
        created_at: Time.zone.now
      )
    ]).page(1))
  end

  it "renders new accept form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: accepts_path, method: "post" do
      assert_select "input#accept_item_identifier", name: "accept[item_identifier]"
    end
  end
end
