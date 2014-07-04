# -*- encoding: utf-8 -*-
require 'spec_helper'

describe Agent do
  #pending "add some examples to (or delete) #{__FILE__}"
  fixtures :all

  it "should set a default required_role to Guest" do
    agent = FactoryGirl.create(:agent)
    agent.required_role.should eq Role.find_by_name('Guest')
  end

  it "should set birth_date" do
    agent = FactoryGirl.create(:agent, :birth_date => '2000')
    agent.date_of_birth.should eq Time.zone.parse('2000-01-01')
  end

  it "should set death_date" do
    agent = FactoryGirl.create(:agent, :death_date => '2000')
    agent.date_of_death.should eq Time.zone.parse('2000-01-01')
  end

  it "should not set death_date earlier than birth_date" do
    agent = FactoryGirl.create(:agent, :birth_date => '2010', :death_date => '2000')
    agent.should_not be_valid
  end

  it "should be creator" do
    agents(:agent_00001).creator?(manifestations(:manifestation_00001)).should be_truthy
  end

  it "should not be creator" do
    agents(:agent_00010).creator?(manifestations(:manifestation_00001)).should be_falsy
  end

  it "should be publisher" do
    agents(:agent_00001).publisher?(manifestations(:manifestation_00001)).should be_truthy
  end

  it "should not be publisher" do
    agents(:agent_00010).publisher?(manifestations(:manifestation_00001)).should be_falsy
  end
end

# == Schema Information
#
# Table name: agents
#
#  id                                  :integer          not null, primary key
#  user_id                             :integer
#  last_name                           :string(255)
#  middle_name                         :string(255)
#  first_name                          :string(255)
#  last_name_transcription             :string(255)
#  middle_name_transcription           :string(255)
#  first_name_transcription            :string(255)
#  corporate_name                      :string(255)
#  corporate_name_transcription        :string(255)
#  full_name                           :string(255)
#  full_name_transcription             :text
#  full_name_alternative               :text
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  deleted_at                          :datetime
#  zip_code_1                          :string(255)
#  zip_code_2                          :string(255)
#  address_1                           :text
#  address_2                           :text
#  address_1_note                      :text
#  address_2_note                      :text
#  telephone_number_1                  :string(255)
#  telephone_number_2                  :string(255)
#  fax_number_1                        :string(255)
#  fax_number_2                        :string(255)
#  other_designation                   :text
#  place                               :text
#  postal_code                         :string(255)
#  street                              :text
#  locality                            :text
#  region                              :text
#  date_of_birth                       :datetime
#  date_of_death                       :datetime
#  language_id                         :integer          default(1), not null
#  country_id                          :integer          default(1), not null
#  agent_type_id                       :integer          default(1), not null
#  lock_version                        :integer          default(0), not null
#  note                                :text
#  required_role_id                    :integer          default(1), not null
#  required_score                      :integer          default(0), not null
#  email                               :text
#  url                                 :text
#  full_name_alternative_transcription :text
#  birth_date                          :string(255)
#  death_date                          :string(255)
#  agent_identifier                    :string(255)
#
