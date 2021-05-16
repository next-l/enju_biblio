require 'rails_helper'

RSpec.describe "periodicals/edit", type: :view do
  before(:each) do
    @periodical = assign(:periodical, Periodical.create!())
  end

  it "renders the edit periodical form" do
    render

    assert_select "form[action=?][method=?]", periodical_path(@periodical), "post" do
    end
  end
end
