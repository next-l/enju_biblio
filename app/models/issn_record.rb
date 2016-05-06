class IssnRecord < ActiveRecord::Base
  belongs_to :periodical
  belongs_to :proceeding
end
