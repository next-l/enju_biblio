class Frequency < ActiveRecord::Base
  include MasterModel
  default_scope { order('frequencies.position') }
  has_many :manifestations
end

# == Schema Information
#
# Table name: frequencies
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  display_name :text
#  note         :text
#  position     :integer          default(1), not null
#  created_at   :datetime
#  updated_at   :datetime
#
