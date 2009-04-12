class FeedsController < ActionController::Base
  layout 'application'

  def index
    @feeds = Feed.find(:all, :include => :posts)
  end

  def create
    feed = Feed.create! :url => params[:url]
    redirect_to :action => :index
  end

  def refresh
    if params[:id]
      Feed.find(params[:id]).fetch
    else
      Feed.fetch_all
    end
    redirect_to :action => :index
  end
end
