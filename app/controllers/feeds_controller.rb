class FeedsController < ActionController::Base
  def index
    @feeds = Feed.find(:all, :include => :posts)
  end

  def create
    feed = Feed.create! :url => params[:url]
    redirect_to :action => :index
  end
end
