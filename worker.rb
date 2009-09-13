require File.dirname(__FILE__) + '/config/environment'

include Minion

job 'feed.fetch' do |args|
  feed = Feed.find_or_new(args['url'])
  feed.perform
end

