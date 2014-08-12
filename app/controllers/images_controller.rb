class ImagesController < ApplicationController

  protect_from_forgery except: :upload
  
  def index
  end

  def download
    image = Image.where(:unique_hash => params[:hash]).first
    send_data open(image.path, "rb") { |f| f.read }
  end

  def thumbnail
    image = Image.where(:unique_hash => params[:hash]).first
    send_data open(image.thumbnail_path, "rb") { |f| f.read }
  end

  def for_entry
    entry = Entry.where(:uuid => params[:uuid]).first
    puts params[:uuid]
    output = { :files => [] }
    entry.images.each do |image|
      output[:files] << image.to_hash
    end
    render :json => output
  end

  def upload
    entry = Entry.find(params[:entry])
    output = { :files => [] }
    result = Image.upload(params[:files].first, entry)
    if result[:success]
      output[:files] << result[:image].to_hash
    else
      output[:files] << { :name => result[:image].filename, :size => result[:image].size, :error => result[:error] }
    end
    render :json => output
  end

  def destroy
    image = Image.where(:unique_hash => params[:hash]).first

    if image.entry.user == current_user
      File.delete(image.path)
      File.delete(image.thumbnail_path)
      image.destroy
      render :json => { :files => Hash[image.filename, true]}
      return
    end
  end
end
