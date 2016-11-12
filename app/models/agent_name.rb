class AgentName < ActiveRecord::Base
  belongs_to :language
  belongs_to :profile
  belongs_to :agent
  acts_as_list scope: :profile_id
end

# == Schema Information
#
# Table name: agent_names
#
#  id          :integer          not null, primary key
#  first_name  :string
#  middle_name :string
#  last_name   :string
#  full_name   :string
#  language_id :integer
#  agent_id    :integer
#  profile_id  :integer
#  position    :integer
#  source      :string
#  name_type   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
