class PictureFile < ActiveRecord::Base
  scope :attached, -> { where('picture_attachable_id IS NOT NULL') }
  belongs_to :picture_attachable, polymorphic: true

  has_one_attached :picture
  validates :picture_attachable_type, presence: true, inclusion: { in: ['Event', 'Manifestation', 'Agent', 'Shelf'] }
  validates_associated :picture_attachable
  default_scope { order('picture_files.position') }
  # http://railsforum.com/viewtopic.php?id=11615
  acts_as_list scope: 'picture_attachable_type=\'#{picture_attachable_type}\''
  strip_attributes only: :picture_attachable_type

  paginates_per 10
end

# == Schema Information
#
# Table name: picture_files
#
#  id                      :bigint           not null, primary key
#  picture_attachable_id   :bigint           not null
#  picture_attachable_type :string           not null
#  title                   :text
#  position                :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  picture_meta            :text
#  picture_fingerprint     :string
#  picture_width           :integer
#  picture_height          :integer
#
