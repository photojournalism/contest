class HomeController < ApplicationController

  def index
    @contest = Contest.current
  end
end
