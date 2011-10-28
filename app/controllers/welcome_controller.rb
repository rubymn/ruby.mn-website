class WelcomeController < ApplicationController

  def index
    @events = Event.approved.all(:order => "scheduled_time desc")

    respond_to do |format|
      format.html
      format.rss
    end
  end
end
