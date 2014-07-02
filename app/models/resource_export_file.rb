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

  def export
    sleep 10
    tempfile = Tempfile.new(['resource_export_file_', '.txt'])
    file = Manifestation.export(format: :tsv)
    tempfile.puts(file)
    tempfile.close
    self.resource_export = File.new(tempfile.path, "r")
    if save
      message = Message.create(
        sender: User.find(1),
        recipient: user.username,
        subject: 'export completed',
        body: I18n.t('export.export_completed')
      )
    end
  end

  private
  def self.transition_class
    ResourceExportFileTransition
  end
end
