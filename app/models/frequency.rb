class Frequency < ActiveRecord::Base
  include MasterModel
  default_scope { order('frequencies.position') }
  has_many :manifestations
end

# == Schema Information
#
# Table name: frequencies
#
#  id           :bigint(8)        not null, primary key
#  name         :string           not null
#  display_name :text
#  note         :text
#  position     :integer          default(1), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
