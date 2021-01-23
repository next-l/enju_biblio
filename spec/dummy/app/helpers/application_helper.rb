# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include EnjuLeaf::ApplicationHelper
  include EnjuBiblio::ApplicationHelper if defined?(EnjuBiblio)
  if defined?(EnjuManifestationViewer)
    include EnjuManifestationViewer::ManifestationViewerHelper
    include EnjuManifestationViewer::BookJacketHelper
  end

    def back_to_index(options = {})
      if options.nil?
        options = {}
      else
        options.reject!{|_key, value| value.blank?}
        options.delete(:page) if options[:page].to_i == 1
      end

      unless controller.controller_name == 'test'
        link_to t('page.listing', model: t("activerecord.models.#{controller.controller_name.singularize}")), url_for(filtered_params.merge(controller: controller.controller_name, action: :index, page: nil, id: nil, only_path: true).merge(options))
      end
    end
end
