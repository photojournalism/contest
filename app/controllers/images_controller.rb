class ImagesController < ApplicationController

  before_action :authenticate_user!
  protect_from_forgery except: :upload

  def download
    image = Image.find_by_unique_hash(params[:hash])
    download_image(image.path)
  end

  def thumbnail
    image = Image.find_by_unique_hash(params[:hash])
    download_image(image.thumbnail_path)
  end

  def for_entry
    entry = Entry.where(:unique_hash => params[:hash]).first
    if entry.user == current_user || current_user.admin
      output = { :files => [] }
      entry.images.each do |image|
        output[:files] << image.to_hash
      end
      render :json => output
      return
    end
    render :nothing => true, :status => 404
  end

  def upload
    entry = Entry.find(params[:entry])
    output = { :files => [] }
    result = Image.upload(params[:files].first, entry)
    if result[:success]
      output[:files] << result[:image].to_hash
    else
      output[:files] << { :error => result[:error] }
    end
    render :json => output
  end

  def destroy
    image = Image.find_by_unique_hash(params[:hash])

    if image.entry.user == current_user || current_user.admin
      image.delete
      render :json => { :files => Hash[image.filename, true]}
      return
    end
    render :nothing => true, :status => 404
  end

  private
  
    def download_image(path)
      send_data open(path, "rb") { |f| f.read }
    end
end
