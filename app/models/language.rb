class Language < ActiveRecord::Base
  include MasterModel
  # If you wish to change the field names for brevity, feel free to enable/modify these.
  # alias_attribute :iso1, :iso_639_1
  # alias_attribute :iso2, :iso_639_2
  # alias_attribute :iso3, :iso_639_3

  # Validations
  validates_presence_of :iso_639_1, :iso_639_2, :iso_639_3
  validates :name, presence: true, format: { with: /\A[0-9A-Za-z][0-9A-Za-z_\-\s,]*[0-9a-z]\Z/ }
  after_save :clear_available_languages_cache
  after_destroy :clear_available_languages_cache

  def self.all_cache
    if Rails.env == 'production'
      Rails.cache.fetch('language_all'){Language.all.to_a}
    else
      Language.all
    end
  end

  def clear_available_languages_cache
    Rails.cache.delete('language_all')
    Rails.cache.delete('available_languages')
  end

  def self.available_languages
    Language.where(iso_639_1: I18n.available_locales.map{|l| l.to_s}).order(:position)
  end

  private

  def valid_name?
    true
  end
end

# == Schema Information
#
# Table name: languages
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  native_name  :string
#  display_name :text
#  iso_639_1    :string
#  iso_639_2    :string
#  iso_639_3    :string
#  note         :text
#  position     :integer
#
