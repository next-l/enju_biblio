class AgentName < ActiveRecord::Base
  belongs_to :language
  belongs_to :profile
  belongs_to :agent
  acts_as_list scope: :profile_id
end
