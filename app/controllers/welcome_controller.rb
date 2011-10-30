class WelcomeController < ApplicationController
  def index
    @events = Event.approved.all(:order => "scheduled_time desc")

    respond_to do |format|
      format.html
      format.rss { render :content_type => 'application/xml' }
    end
  end
end
