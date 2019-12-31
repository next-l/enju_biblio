require 'rails_helper'

RSpec.describe 'Manifestations', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all
  before do
    @item = FactoryBot.create(:item, shelf: shelves(:shelf_00002))
    CarrierType.find_by(name: 'volume').attachment.attach(io: File.open("#{Rails.root.to_s}/../../app/assets/images/icons/book.png"), filename: 'attachment.png')
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

    it 'should show price' do
      @item.update(price: '1500')
      visit item_path(@item.id, locale: :ja)
      expect(page).to have_content @item.price
    end

    it 'should show budget_type' do
      budget_type = BudgetType.find(1)
      @item.update(budget_type: budget_type)
      visit item_path(@item.id, locale: :ja)
      expect(page).to have_content budget_type.display_name_ja
    end

    it 'should show bookstore' do
      bookstore = Bookstore.find(2)
      @item.update(bookstore: bookstore)
      visit item_path(@item.id, locale: :ja)
      expect(page).to have_content bookstore.name
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

    it 'should not show price' do
      @item.update(price: '1500')
      visit item_path(@item.id, locale: :ja)
      expect(page).not_to have_content @item.price
    end

    it 'should not show budget_type' do
      budget_type = BudgetType.find(1)
      @item.update(budget_type: budget_type)
      visit item_path(@item.id, locale: :ja)
      expect(page).not_to have_content budget_type.display_name
    end

    it 'should not show bookstore' do
      bookstore = Bookstore.find(2)
      @item.update(bookstore: bookstore)
      visit item_path(@item.id, locale: :ja)
      expect(page).not_to have_content bookstore.name
    end
  end

  describe 'When not logged in' do
    it 'should not show memo' do
      @item.update(memo: 'memo')
      visit item_path(@item.id, locale: :ja)
      expect(page).not_to have_content @item.memo
    end

    it 'should not show budget_type' do
      budget_type = BudgetType.find(1)
      @item.update(budget_type: budget_type)
      visit item_path(@item.id, locale: :ja)
      expect(page).not_to have_content budget_type.display_name
    end

    it 'should not show bookstore' do
      bookstore = Bookstore.find(2)
      @item.update(bookstore: bookstore)
      visit item_path(@item.id, locale: :ja)
      expect(page).not_to have_content bookstore.name
    end

    it 'should not show price' do
      @item.update(price: '1500')
      visit item_path(@item.id, locale: :ja)
      expect(page).not_to have_content @item.price
    end
  end
end
