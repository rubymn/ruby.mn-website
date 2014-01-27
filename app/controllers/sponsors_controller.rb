class SponsorsController < ApplicationController

  def index
    @current_sponsors = Sponsor.where(current:true).order('RANDOM()')
    @past_sponsors = Sponsor.where(current:false).order('RANDOM()')
  end

end
