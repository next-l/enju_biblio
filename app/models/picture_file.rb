class PictureFile < ActiveRecord::Base
  scope :attached, -> { where('picture_attachable_id IS NOT NULL') }
  belongs_to :picture_attachable, polymorphic: true, validate: true

  if ENV['ENJU_STORAGE'] == 's3'
    has_attached_file :picture, storage: :s3, styles: { medium: "600x600>", thumb: "100x100>" },
      s3_credentials: {
        access_key: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        bucket: ENV['S3_BUCKET_NAME'],
        s3_host_name: ENV['S3_HOST_NAME']
      },
      s3_permissions: :private
  else
    has_attached_file :picture, styles: { medium: "600x600>", thumb: "100x100>" },
      path: ":rails_root/private/system/:class/:attachment/:id_partition/:style/:filename"
  end
  validates_attachment_presence :picture
  validates_attachment_content_type :picture, content_type: ["image/jpeg", "image/pjpeg", "image/png", "image/gif", "image/svg+xml"], on: :create

  validates :picture_attachable_type, presence: true, inclusion: { in: ['Event', 'Manifestation', 'Agent', 'Shelf'] }
  validates_associated :picture_attachable
  default_scope { order('picture_files.position') }
  # http://railsforum.com/viewtopic.php?id=11615
  acts_as_list scope: 'picture_attachable_type=\'#{picture_attachable_type}\''
  normalize_attributes :picture_attachable_type

  paginates_per 10
end

# == Schema Information
#
# Table name: picture_files
#
#  id                      :integer          not null, primary key
#  picture_attachable_id   :integer
#  picture_attachable_type :string(255)
#  content_type            :string(255)
#  title                   :text
#  thumbnail               :string(255)
#  position                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  picture_file_name       :string(255)
#  picture_content_type    :string(255)
#  picture_file_size       :integer
#  picture_updated_at      :datetime
#  picture_meta            :text
#  picture_fingerprint     :string(255)
#
