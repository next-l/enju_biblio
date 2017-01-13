class IsbnRecord < ActiveRecord::Base
  belongs_to :manifestation

  def self.new_records(isbn_records_params)
    return [] unless isbn_records_params
    isbn_records = []
    IsbnRecord.transaction do
      isbn_records_params.each do |k, v|
        next if v['_destroy'] == '1'
        if v['isbn_record_id'].present?
          isbn_record = IsbnRecord.find(v['isbn_record_id'])
        elsif v['id'].present?
          isbn_record = IsbnRecord.find(v['id'])
        else
          v.delete('_destroy')
          isbn_record = IsbnRecord.create(v)
        end
        isbn_records << isbn_record
      end
    end
    isbn_records
  end
end

# == Schema Information
#
# Table name: isbn_records
#
#  id               :integer          not null, primary key
#  body             :string           not null
#  isbn_type        :string
#  source           :string
#  manifestation_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
