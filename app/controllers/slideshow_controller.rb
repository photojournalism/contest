class SlideshowController < ApplicationController

  before_action :require_admin

  def index
    @contest = if params[:year] then Contest.where(:year => params[:year]).first else Contest.current end
    @slideshow_images = []
    if @contest.winning_entries > 0
      @contest.entries.each do |entry|
        if !entry.place || entry.place.sequence_number.to_i == 99
          next
        end

        image = entry.sorted_images[0]
        if image
          @slideshow_images << image
        end
      end
    end
    render :layout => false
  end
end