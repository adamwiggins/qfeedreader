class FeedsController < ActionController::Base
  layout 'application'

  def index
    @feeds = Feed.find(:all, :include => :posts)
  end

  def show
    @feed = Feed.find(params[:id])

    if stale?(:last_modified => @feed.updated_at)
      render :partial => 'feed', :locals => { :feed => @feed }
    else
      response['Cache-Control'] = 'public, max-age=1'
    end
  end

  def create
    Feed.enqueue(params[:url])
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
