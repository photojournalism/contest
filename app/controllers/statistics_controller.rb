class StatisticsController < ApplicationController

  before_action :require_admin

  def index
    @contest = Contest.current

    @number_of_entries = @contest.entries.size
    @number_of_images = 0
    users = []

    @contest.entries.each do |entry|
      users << entry.user.name
      @number_of_images += entry.images.length
    end

    @number_of_users = users.uniq.length
  end
end