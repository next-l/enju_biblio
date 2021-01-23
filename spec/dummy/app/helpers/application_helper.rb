# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include EnjuLeaf::ApplicationHelper
  include EnjuBiblio::ApplicationHelper if defined?(EnjuBiblio)
  if defined?(EnjuManifestationViewer)
    include EnjuManifestationViewer::ManifestationViewerHelper
    include EnjuManifestationViewer::BookJacketHelper
  end
end
