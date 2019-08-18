require 'rails_helper'

describe Item do
  # pending "add some examples to (or delete) #{__FILE__}"
  fixtures :all

  it "should have library_url" do
    items(:item_00001).library_url.should eq "#{LibraryGroup.site_config.url}libraries/web"
  end
end

# == Schema Information
#
# Table name: items
#
#  id                      :bigint           not null, primary key
#  call_number             :string
#  item_identifier         :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  shelf_id                :integer          default(1), not null
#  include_supplements     :boolean          default(FALSE), not null
#  note                    :text
#  url                     :string
#  price                   :integer
#  lock_version            :integer          default(0), not null
#  required_role_id        :integer          default(1), not null
#  required_score          :integer          default(0), not null
#  acquired_at             :datetime
#  bookstore_id            :integer
#  budget_type_id          :integer
#  circulation_status_id   :integer          default(5), not null
#  checkout_type_id        :integer          default(1), not null
#  binding_item_identifier :string
#  binding_call_number     :string
#  binded_at               :datetime
#  manifestation_id        :integer          not null
#  memo                    :text
#
