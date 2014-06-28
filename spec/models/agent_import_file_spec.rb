# -*- encoding: utf-8 -*-
require 'spec_helper'

describe AgentImportFile do
  fixtures :all

  describe "when its mode is 'create'" do
    before(:each) do
      @file = AgentImportFile.create! :agent_import => File.new("#{Rails.root.to_s}/../../examples/agent_import_file_sample1.tsv")
    end

    it "should be imported" do
      old_agents_count = Agent.count
      old_import_results_count = AgentImportResult.count
      @file.current_state.should eq 'pending'
      @file.import_start.should eq({:agent_imported => 3, :user_imported => 0, :failed => 0})
      Agent.order('id DESC')[0].full_name.should eq '原田 ushi 隆史'
      Agent.order('id DESC')[1].full_name.should eq '田辺浩介'
      Agent.order('id DESC')[2].date_of_birth.should eq Time.zone.parse('1978-01-01')
      Agent.count.should eq old_agents_count + 3
      AgentImportResult.count.should eq old_import_results_count + 4

      @file.agent_import_fingerprint.should be_true
      @file.executed_at.should be_true
    end
  end

  describe "when it is written in shift_jis" do
    before(:each) do
      @file = AgentImportFile.create! :agent_import => File.new("#{Rails.root.to_s}/../../examples/agent_import_file_sample3.tsv")
    end

    it "should be imported" do
      old_agents_count = Agent.count
      old_import_results_count = AgentImportResult.count
      @file.current_state.should eq 'pending'
      @file.import_start.should eq({:agent_imported => 4, :user_imported => 0, :failed => 0})
      Agent.count.should eq old_agents_count + 4
      Agent.order('id DESC')[0].full_name.should eq '原田 ushi 隆史'
      Agent.order('id DESC')[1].full_name.should eq '田辺浩介'
      Agent.order('id DESC')[2].email.should eq 'fugafuga@example.jp'
      Agent.order('id DESC')[3].required_role.should eq Role.find_by_name('Guest')
      Agent.order('id DESC')[1].email.should eq 'tanabe@library.example.jp'
      AgentImportResult.count.should eq old_import_results_count + 5

      @file.agent_import_fingerprint.should be_true
      @file.executed_at.should be_true
    end
  end

  describe "when its mode is 'update'" do
    it "should update users" do
      @file = AgentImportFile.create :agent_import => File.new("#{Rails.root.to_s}/../../examples/agent_update_file.tsv")
      @file.modify
      agent_1 = Agent.find(1)
      agent_1.full_name.should eq 'たなべこうすけ'
      agent_1.address_1.should eq '東京都'
      agent_2 = Agent.find(2)
      agent_2.full_name.should eq '田辺浩介'
      agent_2.address_1.should eq '岡山県'
    end
  end

  describe "when its mode is 'destroy'" do
    it "should remove users" do
      old_count = Agent.count
      @file = AgentImportFile.create :agent_import => File.new("#{Rails.root.to_s}/../../examples/agent_delete_file.tsv")
      @file.remove
      Agent.count.should eq old_count - 7
    end
  end
end

# == Schema Information
#
# Table name: agent_import_files
#
#  id                        :integer          not null, primary key
#  parent_id                 :integer
#  content_type              :string(255)
#  size                      :integer
#  user_id                   :integer
#  note                      :text
#  executed_at               :datetime
#  state                     :string(255)
#  agent_import_file_name    :string(255)
#  agent_import_content_type :string(255)
#  agent_import_file_size    :integer
#  agent_import_updated_at   :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  agent_import_fingerprint  :string(255)
#  error_message             :text
#  edit_mode                 :string(255)
#  user_encoding             :string(255)
#

