require 'rails_helper'

RSpec.describe 'Manifestations', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all
  before do
    @manifestation = manifestations(:manifestation_00001)
    @removed_manifestation = manifestations(:manifestation_00102)
    @item = FactoryBot.create(:item, manifestation: @manifestation)
    CarrierType.find_by(name: 'volume').update(attachment: File.open("#{Rails.root.to_s}/../../app/assets/images/icons/book.png"))
    @manifestation.picture_files.first.update(picture: File.open("#{Rails.root.to_s}/../../app/assets/images/icons/dvd.png"))
    FactoryBot.create(:withdraw, item: @item)
  end

  describe 'When logged in as Librarian' do
    before do
      sign_in users(:librarian1)
    end

    it 'should show default item' do
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).to have_content @item.item_identifier
    end
  end

  describe 'When logged in as User' do
    before do
      sign_in users(:user1)
    end

    it 'should show default item' do
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).to have_content @item.item_identifier
    end
  end

  describe 'When not logged in' do
    it 'should show default item' do
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).to have_content @item.item_identifier
    end
  end
end
