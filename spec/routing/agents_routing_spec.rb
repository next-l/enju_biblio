# == Schema Information
#
# Table name: agents
#
#  id                                  :integer          not null, primary key
#  last_name                           :string
#  middle_name                         :string
#  first_name                          :string
#  last_name_transcription             :string
#  middle_name_transcription           :string
#  first_name_transcription            :string
#  corporate_name                      :string
#  corporate_name_transcription        :string
#  full_name                           :string
#  full_name_transcription             :text
#  full_name_alternative               :text
#  created_at                          :datetime
#  updated_at                          :datetime
#  deleted_at                          :datetime
#  zip_code_1                          :string
#  zip_code_2                          :string
#  address_1                           :text
#  address_2                           :text
#  address_1_note                      :text
#  address_2_note                      :text
#  telephone_number_1                  :string
#  telephone_number_2                  :string
#  fax_number_1                        :string
#  fax_number_2                        :string
#  other_designation                   :text
#  place                               :text
#  postal_code                         :string
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
#  birth_date                          :string
#  death_date                          :string
#  agent_identifier                    :string
#  profile_id                          :integer
#

require "spec_helper"

describe AgentsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/agents" }.should route_to(:controller => "agents", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/agents/new" }.should route_to(:controller => "agents", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/agents/1" }.should route_to(:controller => "agents", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/agents/1/edit" }.should route_to(:controller => "agents", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/agents" }.should route_to(:controller => "agents", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/agents/1" }.should route_to(:controller => "agents", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/agents/1" }.should route_to(:controller => "agents", :action => "destroy", :id => "1")
    end

  end
end
