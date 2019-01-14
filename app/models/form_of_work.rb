class FormOfWork < ActiveRecord::Base
  include MasterModel
  include Mobility
  translates :display_name
  default_scope { order('form_of_works.position') }
  has_many :works
end

# == Schema Information
#
# Table name: form_of_works
#
#  id           :bigint(8)        not null, primary key
#  name         :string           not null
#  display_name :jsonb            not null
#  note         :text
#  position     :integer          default(1), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
