class IssnRecord < ActiveRecord::Base
  belongs_to :manifestation
  validates :body, presence: true, uniqueness: {scope: :issn_type}

  def self.new_records(issn_records_params)
    return [] unless issn_records_params
    issn_records = []
    IssnRecord.transaction do
      issn_records_params.each do |k, v|
        next if v['_destroy'] == '1'
        if v['issn_record_id'].present?
          issn_record = IssnRecord.find(v['issn_record_id'])
        elsif v['id'].present?
          issn_record = IssnRecord.find(v['id'])
        else
          v.delete('_destroy')
          issn_record = IssnRecord.create(v)
        end
        issn_records << issn_record
      end
    end
    issn_records
  end
end

# == Schema Information
#
# Table name: issn_records
#
#  id               :integer          not null, primary key
#  body             :string           not null
#  issn_type        :string
#  source           :string
#  manifestation_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
