require 'rails_helper'

RSpec.describe 'Manifestations', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all
  before do
    @item = FactoryBot.create(:item, shelf: shelves(:shelf_00002))
    CarrierType.find_by(name: 'volume').attachment.attach(io: File.open("#{Rails.root}/../fixtures/files/spinner.gif"), filename: 'attachment.gif')
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

    it 'should show memo' do
      @item.manifestation.update(memo: 'memo')
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).to have_content @item.manifestation.memo
    end

    it 'should show custom properties' do
      @item.manifestation.manifestation_custom_values << FactoryBot.build(:manifestation_custom_value)
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).to have_content @item.manifestation.manifestation_custom_values.first.value
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

    it 'should not show memo' do
      @item.manifestation.update(memo: 'memo')
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).not_to have_content @item.manifestation.memo
    end

    it 'should not show custom properties' do
      @item.manifestation.manifestation_custom_values << FactoryBot.build(:manifestation_custom_value)
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).not_to have_content @item.manifestation.manifestation_custom_values.first.value
    end
  end

  describe 'When not logged in' do
    it 'should show default item' do
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).to have_content @item.item_identifier
    end

    it 'should not show memo' do
      @item.manifestation.update(memo: 'memo')
      visit manifestation_path(@item.manifestation.id, locale: :ja)
      expect(page).not_to have_content @item.manifestation.memo
    end
  end
end
