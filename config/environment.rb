RAILS_GEM_VERSION = '2.3.5'

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
  config.gem 'feedtools', :lib => 'feed_tools'
  config.gem 'stalker'
end
