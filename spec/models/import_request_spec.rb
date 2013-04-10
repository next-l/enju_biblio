# -*- encoding: utf-8 -*-
require 'spec_helper'

describe ImportRequest do
  context "import" do
    it "should import bibliographic record", :vcr => true, :solr => true do
      old_count = Manifestation.count
      import_request = ImportRequest.create(:isbn => '9784797350999')
      import_request.import!
      Manifestation.count.should eq old_count + 1
    end
  end
end

# == Schema Information
#
# Table name: import_requests
#
#  id               :integer          not null, primary key
#  isbn             :string(255)
#  state            :string(255)
#  manifestation_id :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

