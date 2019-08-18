require 'rails_helper'

RSpec.describe 'Manifestations', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all
  before do
    @item = FactoryBot.create(:item, shelf: shelves(:shelf_00002))
    CarrierType.find_by(name: 'volume').update(attachment: File.open("#{Rails.root.to_s}/../../app/assets/images/icons/book.png"))
    FactoryBot.create(:withdraw, item: @item)
  end

  describe 'When logged in as Librarian' do
    before do
      sign_in users(:librarian1)
    end

    it 'should show memo' do
      @item.update(memo: 'memo')
      visit item_path(@item.id, locale: :ja)
      expect(page).to have_content @item.memo
    end
  end

  describe 'When logged in as User' do
    before do
      sign_in users(:user1)
    end

    it 'should not show memo' do
      @item.update(memo: 'memo')
      visit item_path(@item.id, locale: :ja)
      expect(page).not_to have_content @item.memo
    end
  end

  describe 'When not logged in' do
    it 'should not show memo' do
      @item.update(memo: 'memo')
      visit item_path(@item.id, locale: :ja)
      expect(page).not_to have_content @item.memo
    end
  end
end
