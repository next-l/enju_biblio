class PictureFile < ActiveRecord::Base
  scope :attached, -> { where('picture_attachable_id IS NOT NULL') }
  belongs_to :picture_attachable, polymorphic: true, validate: true

  include AttachmentUploader[:image]

  # http://railsforum.com/viewtopic.php?id=11615
  acts_as_list scope: 'picture_attachable_type=\'#{picture_attachable_type}\''
  validates :picture_attachable_type, presence: true, inclusion: { in: ['Event', 'Manifestation', 'Agent', 'Shelf'] }
  before_create :set_fingerprint
  strip_attributes only: :picture_attachable_type

  paginates_per 10

  def set_fingerprint
    return nil unless image
    self.picture_fingerprint = Digest::SHA1.file(image.download.path).hexdigest
  end
end

# == Schema Information
#
# Table name: picture_files
#
#  id                      :integer          not null, primary key
#  picture_attachable_id   :integer
#  picture_attachable_type :string
#  content_type            :string
#  title                   :text
#  thumbnail               :string
#  position                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  picture_meta            :text
#  picture_fingerprint     :string
#  image_data              :jsonb
#
