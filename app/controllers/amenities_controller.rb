class AmenitiesController < ApplicationController
  def new
    @amenity = Amenity.new
  end

  def show
    @amenity = Amenity.find(params[:id])
  end
end
