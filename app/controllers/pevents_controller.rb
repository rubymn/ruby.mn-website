class PeventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
  end

  def index
    render :xml=> Event.rss
  end
end
