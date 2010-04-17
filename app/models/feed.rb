class Feed < ActiveRecord::Base
  has_many :posts

  after_create :fetch

  def self.enqueue(url)
    Stalker.enqueue('feed.fetch', :url => url)
  end

  def fetch
    self.class.enqueue(url)
  end

  def perform
    feed = FeedTools::Feed.open(url)

    transaction do
      self.title = feed.title
      self.updated_at = Time.now
      save!

      feed.items.slice(0, 3).each do |item|
        unless posts.find_by_url(item.link)
          posts.create! :title => item.title, :url => item.link
        end
      end
    end
  end

  def self.fetch_all
    all.each do |feed|
      feed.fetch
    end
  end

  def self.find_or_new(url)
    find_by_url(url) || Feed.new(:url => url)
  end
end
