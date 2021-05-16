require 'rails_helper'

RSpec.describe "periodicals/index", type: :view do
  before(:each) do
    assign(:periodicals, [
      Periodical.create!(),
      Periodical.create!()
    ])
  end

  it "renders a list of periodicals" do
    render
  end
end
