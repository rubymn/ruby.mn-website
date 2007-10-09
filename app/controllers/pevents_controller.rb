class PeventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
  end

  def rss
    render :xml=> Event.rss
  end
end
