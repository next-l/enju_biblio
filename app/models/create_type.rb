class CreateType < ActiveRecord::Base
  include MasterModel
  include Mobility
  translates :display_name
  default_scope { order('create_types.position') }
end

# == Schema Information
#
# Table name: create_types
#
#  id           :bigint(8)        not null, primary key
#  name         :string
#  display_name :jsonb            not null
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
