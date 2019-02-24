require 'rails_helper'

describe AgentImportFile do
  fixtures :all

  describe "when its mode is 'create'" do
    before(:each) do
      @file = AgentImportFile.create!(user: users(:admin))
      @file.agent_import.attach(io: File.new("#{Rails.root}/../../examples/agent_import_file_sample1.tsv"), filename: 'attachment.txt')
    end

    it "should be imported" do
      old_agents_count = Agent.count
      old_import_results_count = AgentImportResult.count
      @file.current_state.should eq 'pending'
      @file.import_start.should eq({agent_imported: 3, user_imported: 0, failed: 0})
      Agent.order('created_at DESC')[0].full_name.should eq '原田 ushi 隆史'
      Agent.order('created_at DESC')[1].full_name.should eq '田辺浩介'
      Agent.order('created_at DESC')[2].date_of_birth.should eq Time.zone.parse('1978-01-01')
      Agent.count.should eq old_agents_count + 3
      @file.agent_import_results.order(:id).first.body.split("\t").first.should eq 'full_name'
      AgentImportResult.count.should eq old_import_results_count + 5

      @file.agent_import.checksum.should be_truthy
      @file.executed_at.should be_truthy
    end
  end

  describe "when it is written in shift_jis" do
    before(:each) do
      @file = AgentImportFile.create!(
        user: users(:admin)
      )
      @file.agent_import.attach(io: File.new("#{Rails.root}/../../examples/agent_import_file_sample3.tsv"), filename: 'attachment.txt')
    end

    it "should be imported" do
      old_agents_count = Agent.count
      old_import_results_count = AgentImportResult.count
      @file.current_state.should eq 'pending'
      @file.import_start.should eq({agent_imported: 4, user_imported: 0, failed: 0})
      Agent.count.should eq old_agents_count + 4
      Agent.order('created_at DESC')[0].full_name.should eq '原田 ushi 隆史'
      Agent.order('created_at DESC')[1].full_name.should eq '田辺浩介'
      AgentImportResult.count.should eq old_import_results_count + 5

      @file.agent_import.checksum.should be_truthy
      @file.executed_at.should be_truthy
    end
  end

  describe "when its mode is 'update'" do
    it "should update users" do
      file = AgentImportFile.create!(
        user: users(:admin)
      )
      file.agent_import.attach(io: File.new("#{Rails.root}/../../examples/agent_update_file.tsv"), filename: 'attachment.txt')
      file.modify
      agent_1 = Agent.find(agents(:agent_00001).id)
      agent_1.full_name.should eq 'たなべこうすけ'
      agent_1.address_1.should eq '東京都'
      agent_2 = Agent.find(agents(:agent_00002).id)
      agent_2.full_name.should eq '田辺浩介'
      agent_2.address_1.should eq '岡山県'
    end
  end

  describe "when its mode is 'destroy'" do
    it "should remove users" do
      old_count = Agent.count
      file = AgentImportFile.create!(
        user: users(:admin)
      )
      file.agent_import.attach(io: File.new("#{Rails.root}/../../examples/agent_delete_file.tsv"), filename: 'attachment.txt')
      file.remove
      Agent.count.should eq old_count - 5
    end
  end

  it "should import in background" do
    file = AgentImportFile.create!(user: users(:admin))
    file.agent_import.attach(io: File.new("#{Rails.root}/../../examples/agent_import_file_sample1.tsv"), filename: 'attachment.txt')
    AgentImportFileJob.perform_later(file).should be_truthy
  end
end

# == Schema Information
#
# Table name: agent_import_files
#
#  id                       :uuid             not null, primary key
#  user_id                  :bigint(8)
#  note                     :text
#  executed_at              :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  agent_import_fingerprint :string
#  error_message            :text
#  edit_mode                :string
#  user_encoding            :string
#
