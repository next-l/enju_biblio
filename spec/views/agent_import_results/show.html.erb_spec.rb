require 'rails_helper'

describe "agent_import_results/show" do
  fixtures :all

  before(:each) do
    @agent_import_result = agent_import_results(:one)
    admin = User.find_by(username: 'enjuadmin')
    view.stub(:current_user).and_return(admin)
  end

  it "renders a agent_import_result" do
    render
    expect(rendered).to match /MyText/
  end
end
