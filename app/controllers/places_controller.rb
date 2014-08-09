class PlacesController < ApplicationController

  before_filter :require_admin

  def index
    @places = Place.all.order(:order)
  end

end
