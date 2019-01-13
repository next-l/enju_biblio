class ContentType < ActiveRecord::Base
  include MasterModel
  default_scope { order('content_types.position') }
  has_many :manifestations
end

# == Schema Information
#
# Table name: content_types
#
#  id           :bigint(8)        not null, primary key
#  name         :string           not null
#  display_name :text
#  note         :text
#  position     :integer          default(1), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
