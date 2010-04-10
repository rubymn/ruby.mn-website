class WelcomeController < ApplicationController

  def index
    @events = Event.approved.find(:all, :order=>"scheduled_time desc")
  end
end
