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
