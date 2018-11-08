class SlideshowController < ApplicationController

  before_action :require_admin

  def index
    @contests = Contest.all
  end

  def slideshow
    @contest = Contest.where(:year => params[:year]).first
    @slideshow_images = []
    @contest.entries
      .select { |e| e.place && e.place.sequence_number.to_i != 99 && !e.category.name.include?('Portfolio') }
      .sort { |a,b| [a.category.name, a.place.sequence_number.to_i] <=> [b.category.name, b.place.sequence_number.to_i] }
      .each do |entry|
      image = entry.sorted_images[0]
      if image
        @slideshow_images << image
      end
    end
    render :layout => false
  end
end