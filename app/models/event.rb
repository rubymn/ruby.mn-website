class Event < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :headline, :scheduled_time, :body, :user_id
  def self.rss
    version="2.0"
    content = RSS::Maker.make(version) do |m|
      m.channel.title="Ruby Users of Minnesota"
      m.channel.link="http://www.ruby.mn"
      m.channel.description="Ruby Users of Minnesota Events"
      m.items.do_sort=true
      find(:all).each do |e|
        i = m.items.new_item
        i.title=e.headline
        i.link = "http://www.ruby.mn/pevents/#{e.id}"
        i.date= e.created_at
        i.description=e.body

      end
    end
    content.to_s

  end
end
