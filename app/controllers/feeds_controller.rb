class FeedsController < ActionController::Base
  layout 'application'

  def index
    @feeds = Feed.find(:all, :include => :posts)
  end

  def show
    @feed = Feed.find(params[:id])
    if since = request.headers['If-Modified-Since']
      if @feed.updated_at > Time.parse(since)
        render :partial => 'feed', :locals => { :feed => @feed }
      else
        head 204, 'Cache-Control' => 'max-age=1'
      end
    end
  end

  def create
    feed = Feed.create! :url => params[:url]
    redirect_to :action => :index
  end

  def refresh
    Feed.find(params[:id]).fetch
    head :ok
  end

  def refresh_all
    Feed.fetch_all
    head :ok
  end
end
