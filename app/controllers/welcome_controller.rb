class WelcomeController < ApplicationController

  def index
      @events = Event.find :all, :order=>"scheduled_time desc"
  end
end
