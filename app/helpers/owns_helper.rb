# == Schema Information
#
# Table name: owns
#
#  id         :integer          not null, primary key
#  agent_id   :integer          not null
#  item_id    :integer          not null
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

module OwnsHelper
  include ManifestationsHelper
end
