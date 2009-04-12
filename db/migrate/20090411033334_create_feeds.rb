class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :url
      t.string :title, :default => '(pending)'
      t.timestamps
    end

    create_table :posts do |t|
      t.integer :feed_id
      t.string :title
      t.string :url
      t.timestamps
    end
  end

  def self.down
  end
end
