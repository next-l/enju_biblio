# -*- encoding: utf-8 -*-
require 'rails_helper'

describe ResourceImportResult do
  #pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: resource_import_results
#
#  id                      :integer          not null, primary key
#  resource_import_file_id :integer
#  manifestation_id        :uuid
#  item_id                 :uuid
#  body                    :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  error_message           :text
#
