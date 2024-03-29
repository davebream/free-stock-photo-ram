require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Week3Homework
  class Application < Rails::Application
    config.paths.add 'contexts/uploading/lib', eager_load: true
    config.paths.add 'contexts/publishing/lib', eager_load: true
    config.paths.add 'contexts/copyright_checking/lib', eager_load: true
    config.paths.add 'contexts/file_processing/lib', eager_load: true
    config.paths.add 'contexts/reviewing/lib', eager_load: true
    config.paths.add 'contexts/tagging/lib', eager_load: true
    config.paths.add 'lib', eager_load: true
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_storage.multiple_file_field_include_hidden = false
  end
end
