require 'rails_helper'

RSpec.describe "periodicals/index", type: :view do
  before(:each) do
    2.times do
      FactoryBot.create(:periodical)
    end
    assign(:periodicals, Periodical.page(1))
  end

  it "renders a list of periodicals" do
    render
  end
end
