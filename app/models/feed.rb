class Feed < ActiveRecord::Base
  has_many :posts

  after_create :fetch

  def fetch
    feed = FeedTools::Feed.open(url)

    transaction do
      self.title = feed.title
      self.updated_at = Time.now
      save!

      feed.items.each do |item|
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
end
