class WelcomeController < ApplicationController

  def index
    @events = Event.find :all, :order=>"scheduled_time desc",:conditions=>"approved=1", :limit=>5, :include=>:user
  end
end
