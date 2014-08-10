class ResourceExportFile < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordModel
  belongs_to :user
  has_attached_file :resource_export
  validates_attachment_content_type :resource_export, :content_type => /\Atext\/plain\Z/
  validates :user, presence: true
  attr_accessible :mode
  attr_accessor :mode

  has_many :resource_export_file_transitions

  def state_machine
    ResourceExportFileStateMachine.new(self, transition_class: ResourceExportFileTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def export!
    transition_to!(:started)
    tempfile = Tempfile.new(['resource_export_file_', '.txt'])
    file = Manifestation.export(format: :txt)
    tempfile.puts(file)
    tempfile.close
    self.resource_export = File.new(tempfile.path, "r")
    if save
      send_message
    end
    transition_to!(:completed)
  rescue => e
    transition_to!(:failed)
    raise e
  end

  private
  def self.transition_class
    ResourceExportFileTransition
  end

  def send_message
    sender = User.find(1)
    message_template = MessageTemplate.localized_template('export_completed', user.locale)
    request = MessageRequest.new
    request.assign_attributes({:sender => sender, :receiver => user, :message_template => message_template}, as: :admin)
    request.save_message_body
    request.transition_to!(:sent)
  end
end

# == Schema Information
#
# Table name: resource_export_files
#
#  id                           :integer          not null, primary key
#  user_id                      :integer
#  resource_export_file_name    :string(255)
#  resource_export_content_type :string(255)
#  resource_export_file_size    :integer
#  resource_export_updated_at   :datetime
#  executed_at                  :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
