RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
  config.gem 'feedtools', :lib => 'feed_tools'
  config.gem 'tmm1-amqp', :lib => 'mq', :source => 'http://gems.github.com'
  config.gem 'bunny'
  config.gem 'minion'
end
