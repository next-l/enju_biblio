class UpgradeEnjuSubjectToEnjuLeaf20 < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up {
        change_table :classifications do |t|
          t.change :classification_type_id, :bigint
          t.change :manifestation_id, :bigint
          t.change :parent_id, :bigint
        end

        change_table :subjects do |t|
          t.change :manifestation_id, :bigint
          t.change :parent_id, :bigint
          t.change :required_role_id, :bigint
          t.change :subject_heading_type_id, :bigint
          t.change :subject_type_id, :bigint
        end

        add_index :subjects, :subject_heading_type_id

        add_foreign_key :classifications, "classifications", column: 'parent_id'
        add_foreign_key :subjects, "subjects", column: 'parent_id'
      }

      dir.down {
        change_table :classifications do |t|
          t.change :classification_type_id, :integer
          t.change :manifestation_id, :integer
          t.change :parent_id, :integer
        end

        change_table :subjects do |t|
          t.change :manifestation_id, :integer
          t.change :parent_id, :integer
          t.change :required_role_id, :integer
          t.change :subject_heading_type_id, :integer
          t.change :subject_type_id, :integer
        end

        remove_index :subjects, :subject_heading_type_id

        remove_foreign_key :classifications, "classifications"
        remove_foreign_key :subjects, "subjects"
      }

      [
        :classification_types,
        :subject_heading_types,
        :subject_types
      ].each do |table|
        change_column_null table, :position, false
        dir.up { change_column table, :position, :integer, default: 1 }
        dir.down { change_column table, :position, :integer, default: nil }
      end

      [
        :classifications,
        :subjects
      ].each do |table|
        dir.up {
          add_foreign_key table, :manifestations
        }
        dir.down {
          remove_foreign_key table, :manifestations
        }
      end
    end

    change_column_null :subjects, :term, false
  end
end
