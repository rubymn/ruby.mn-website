class WelcomeController < ApplicationController

  def index
    @events = Event.find :all, :order=>"scheduled_time desc",:conditions=>"approved=true", :limit=>5, :include=>:user
  end
end
