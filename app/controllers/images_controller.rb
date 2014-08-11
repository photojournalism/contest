class ImagesController < ApplicationController

  protect_from_forgery except: :upload
  
  def index
  end

  def upload
  end
end
