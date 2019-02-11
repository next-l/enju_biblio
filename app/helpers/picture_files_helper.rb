module PictureFilesHelper
  def show_image(picture_file, options = {size: :medium})
    return nil unless picture_file.picture.attached?

    case options[:size]
    when :medium
      if picture_file.picture_width.to_i >= 600
        return image_tag picture_file.picture.variant(resize: '600x'), alt: "*", width: 600
      end
    when :thumb
      if picture_file.picture_width.to_i >= 100
        return image_tag picture_file.picture.variant(resize: '100x'), alt: "*", width: 100
      end
    end
    image_tag picture_file.picture, alt: "*", width: picture_file.picture.metadata['width'], height: picture_file.picture.metadata['height']
  end
end
