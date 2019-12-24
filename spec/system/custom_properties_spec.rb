require 'rails_helper'

RSpec.describe 'CustomProperties', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  describe 'Manifestation' do
    before do
      @manifestation = FactoryBot.create(:manifestation_custom_property).resource
      CarrierType.find_by(name: 'volume').update(attachment: File.open("#{Rails.root.to_s}/../../app/assets/images/icons/book.png"))
    end

    describe 'When logged in as Librarian' do
      before do
        sign_in users(:librarian1)
      end

      it 'should show custom property' do
        visit manifestation_path(@manifestation.id, locale: :ja)
        expect(page).to have_content @manifestation.custom_properties.first.label
        expect(page).to have_content @manifestation.custom_properties.first.value
      end
    end

    describe 'When logged in as User' do
      before do
        sign_in users(:user1)
      end

      it 'should not show custom property' do
        visit manifestation_path(@manifestation.id, locale: :ja)
        expect(page).not_to have_content @manifestation.custom_properties.first.label
        expect(page).not_to have_content @manifestation.custom_properties.first.value
      end
    end

    describe 'When not logged in' do
      it 'should not show custom property' do
        visit manifestation_path(@manifestation.id, locale: :ja)
        expect(page).not_to have_content @manifestation.custom_properties.first.label
        expect(page).not_to have_content @manifestation.custom_properties.first.value
      end
    end
  end

  describe 'Item' do
    before do
      @item = FactoryBot.create(:item_custom_property).resource
      CarrierType.find_by(name: 'volume').update(attachment: File.open("#{Rails.root.to_s}/../../app/assets/images/icons/book.png"))
    end

    describe 'When logged in as Librarian' do
      before do
        sign_in users(:librarian1)
      end

      it 'should show custom property' do
        visit item_path(@item.id, locale: :ja)
        expect(page).to have_content @item.custom_properties.first.label
        expect(page).to have_content @item.custom_properties.first.value
      end
    end

    describe 'When logged in as User' do
      before do
        sign_in users(:user1)
      end

      it 'should not show custom property' do
        visit item_path(@item.id, locale: :ja)
        expect(page).not_to have_content @item.custom_properties.first.label
        expect(page).not_to have_content @item.custom_properties.first.value
      end
    end

    describe 'When not logged in' do
      it 'should not show custom property' do
        visit item_path(@item.id, locale: :ja)
        expect(page).not_to have_content @item.custom_properties.first.label
        expect(page).not_to have_content @item.custom_properties.first.value
      end
    end
  end
end
