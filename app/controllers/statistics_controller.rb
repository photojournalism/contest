class StatisticsController < ApplicationController

  before_action :require_admin

  def index(year=nil)
    if year
      @contest = Contest.where(:year => year).first
      if !@contest
        @contest = Contest.current
      end
    else
      @contest = Contest.current
    end

    @number_of_entries = @contest.entries.size
    @number_of_images = 0
    @category_counts = {}
    users = []

    @contest.entries.each do |entry|
      if !entry.pending
        users << entry.user.name
        @number_of_images += entry.images.length
        if (!@category_counts[entry.category.name])
          @category_counts[entry.category.name] = 0
        end
        @category_counts[entry.category.name] += 1
      end
    end

    @number_of_users = users.uniq.length
  end
end