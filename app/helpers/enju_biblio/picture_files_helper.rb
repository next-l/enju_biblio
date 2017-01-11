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
#  picture_filename        :string
#  picture_content_type    :string
#  picture_size            :integer
#  picture_updated_at      :datetime
#  picture_meta            :text
#  picture_fingerprint     :string
#  picture_id              :string
#

module EnjuBiblio
  module PictureFilesHelper
    def show_image(picture_file, options = {size: :medium})
      case options[:size]
      when :medium
        if picture_file.image[:original].metadata['width'].to_i >= 600
          return image_tag picture_file_path(picture_file, format: :download, size: :medium), alt: "*", width: picture_file.image[:small].metadata['width'], height: picture_file.image[:small].metadata['height']
        end
      when :thumb
        if picture_file.image[:original].metadata['width'].to_i >= 100
          return image_tag picture_file_path(picture_file, format: :download, size: :medium), alt: "*", width: picture_file.image[:thumbnail].metadata['width'], height: picture_file.image[:thumbnail].metadata['height']
        end
      end
      image_tag picture_file_path(picture_file, format: :download, size: :medium), alt: "*", width: picture_file.image[:original].metadata['width'], height: picture_file.image[:original].metadata['height']
    end
  end
end
