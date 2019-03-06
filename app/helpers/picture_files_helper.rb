module PictureFilesHelper
  def show_image(picture_file, options = {size: :medium})
    return nil unless picture_file.picture.attached?

    case options[:size]
    when :medium
      return image_tag picture_file.picture.variant(resize: '600x'), alt: "*"
    when :thumb
      return image_tag picture_file.picture.variant(resize: '100x'), alt: "*"
    end
    image_tag picture_file.picture, alt: "*", width: picture_file.picture.metadata['width'], height: picture_file.picture.metadata['height']
  end
end
