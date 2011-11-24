class WelcomeController < ApplicationController
  def index
    @events = Event.approved.order_scheduled_time_desc

    respond_to do |format|
      format.html
      format.rss { render :content_type => 'application/xml' }
    end
  end
end
