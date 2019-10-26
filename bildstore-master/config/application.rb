require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bildstore
	class Application < Rails::Application
		# Initialize configuration defaults for originally generated Rails version.
		config.load_defaults 5.1

		config.autoload_paths += %w(#{config.root}/app/models/ckeditor)
		config.autoload_paths += %W(#{config.root}/lib)
		# config.exception_handler = { dev: true }
		# config.exception_handler = {
		# 	email: "sandeep.kumar@bridgeconn.com"
		# }
		config.exceptions_app = self.routes



		# Settings in config/environments/* take precedence over those specified here.
		# Application configuration should go into files in config/initializers
		# -- all .rb files in that directory are automatically loaded.
	end
end
