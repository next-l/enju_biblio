class ItemTransition < ActiveRecord::Base
  #include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :item, inverse_of: :item_transitions
  #attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: item_transitions
#
#  id          :integer          not null, primary key
#  to_state    :string           not null
#  metadata    :jsonb
#  sort_key    :integer          not null
#  item_id     :uuid             not null
#  most_recent :boolean          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
