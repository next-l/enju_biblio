class CarrierType < ActiveRecord::Base
  attr_accessible :name, :display_name, :note, :position
  include MasterModel
  default_scope { order("carrier_types.position") }
  has_many :manifestations
  if defined?(EnjuCirculation)
    attr_accessible :carrier_type_has_checkout_types_attributes
    has_many :carrier_type_has_checkout_types, dependent: :destroy
    has_many :checkout_types, through: :carrier_type_has_checkout_types
    accepts_nested_attributes_for :carrier_type_has_checkout_types, allow_destroy: true, reject_if: :all_blank
  end

  def mods_type
    case name
    when 'volume'
      'text'
    else
      # TODO: その他のタイプ
      'software, multimedia'
    end
  end
end

# == Schema Information
#
# Table name: carrier_types
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#
