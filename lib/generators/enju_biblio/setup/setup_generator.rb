class EnjuBiblio::SetupGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_setup_files
    directory("db/fixtures", "db/fixtures/enju_biblio")
    rake("enju_biblio_engine:install:migrations")
  end
end
