require 'rails_helper'

RSpec.describe 'Users', type: :system do
  it 'should show item' do
    visit items_path
    expect(page).to have_content 'Item'
  end
end
