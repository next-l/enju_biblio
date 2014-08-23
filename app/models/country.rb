class Country < ActiveRecord::Base
  attr_accessible :name, :display_name, :alpha_2, :alpha_3, :numeric_3, :note
  include MasterModel
  default_scope { order('countries.position') }
  has_many :agents
  has_many :libraries
  has_one :library_group

  # If you wish to change the field names for brevity, feel free to enable/modify these.
  # alias_attribute :iso, :alpha_2
  # alias_attribute :iso3, :alpha_3
  # alias_attribute :numeric, :numeric_3

  # Validations
  validates_presence_of :alpha_2, :alpha_3, :numeric_3
  validates :name, presence: true, format: { with: /\A[0-9A-Za-z][0-9A-Za-z_\-\s,]*[0-9a-z]\Z/ }

  after_save :clear_all_cache
  after_destroy :clear_all_cache

  def self.all_cache
    Rails.cache.fetch('country_all'){Country.all.to_a}
  end

  def clear_all_cache
    Rails.cache.delete('country_all')
  end

  private

  def valid_name?
    true
  end
end

# == Schema Information
#
# Table name: countries
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  display_name :text
#  alpha_2      :string(255)
#  alpha_3      :string(255)
#  numeric_3    :string(255)
#  note         :text
#  position     :integer
#

