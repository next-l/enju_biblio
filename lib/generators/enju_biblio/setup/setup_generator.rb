class EnjuBiblio::SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :file, type: :string, default: "all"

  def copy_setup_files
    directory("db/fixtures", "db/fixtures/enju_biblio")
    return if file == 'fixture'
    inject_into_class 'app/controllers/application_controller.rb', ApplicationController,
      "  include EnjuBiblio::Controller\n"
    append_to_file("config/schedule.rb", File.open(File.expand_path('../templates', __FILE__) + '/config/schedule.rb').read)
  end
end
