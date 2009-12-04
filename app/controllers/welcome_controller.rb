class WelcomeController < ApplicationController

  def index
    @events = Event.approved
  end
end
