class PeventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
  end

  def rss
    version="2.0"
    content = RSS::Maker.make(version) do |m|
      m.channel.title="Ruby Users of Minnesota"
      m.channel.link="http://www.ruby.mn"
      m.channel.description="Ruby Users of Minnesota Events"
      m.items.do_sort=true
      Event.find(:all, :conditions=>'approved=1').each do |e|
        i = m.items.new_item
        i.title=e.headline
        i.link = pevent_url(e)
        i.date= e.created_at
        i.description=BlueCloth::new(e.body).to_html
      end
    end
      render :xml=> content.to_s
  end
end
