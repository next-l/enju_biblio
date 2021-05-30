require 'rails_helper'

RSpec.describe "periodicals/show", type: :view do
  before(:each) do
    @periodical = assign(:periodical, FactoryBot.create(:periodical))
  end

  it "renders attributes in <p>" do
    render
  end
end
