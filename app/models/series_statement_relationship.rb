class SeriesStatementRelationship < ActiveRecord::Base
  attr_accessible :child_id, :parent_id
  belongs_to :parent, :foreign_key => 'parent_id', :class_name => 'SeriesStatement'
  belongs_to :child, :foreign_key => 'child_id', :class_name => 'SeriesStatement'
end
