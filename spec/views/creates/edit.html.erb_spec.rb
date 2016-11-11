require 'rails_helper'

describe "creates/edit" do
  fixtures :create_types

  before(:each) do
    @create = assign(:create, stub_model(Create,
      :work_id => 1,
      :agent_id => 1
    ))
    @create_types = CreateType.all
  end

  it "renders the edit create form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => creates_path(@create), :method => "post" do
      assert_select "input#create_work_id", :name => "create[work_id]"
    end
  end
end
