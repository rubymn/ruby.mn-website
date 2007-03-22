class WelcomeController < ApplicationController

  def index
    @events = Event.find :all, :order=>"scheduled_time desc", :limit=>5
  end
end
