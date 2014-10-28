class Image < ActiveRecord::Base
  validates_presence_of :filename, :original_filename, :size, :location, :entry, :unique_hash, :caption, :number

  belongs_to :entry

  # Deletes all image instances and files on the filesystem
  def self.delete_all
    Image.all.each do |image|
      image.delete
    end
  end

  # Finds an image by a unique hash
  #
  # @param unique_hash [String] The unique hash of the image.
  def self.find_by_unique_hash(unique_hash)
    Image.where(:unique_hash => unique_hash).first
  end

  # Creates the image instance and writes the image and thumbnail
  # to the filesystem.
  #
  # @param image [ActionDispatch::Http::UploadedFile] The image from the client.
  # @param entry [Entry] The entry to associate this image with.
  def self.upload(image, entry)
    image_number = File.basename(image.original_filename, ".*")[-2..-1]
    if !(image_number =~ /\d\d/)
      return { :success => false, :error => "Image filename must end with underscore, then two-digit number. i.e., 'filename_01.jpg'"}
    end

    upload_dir = entry.images_location
    i = Image.new(
      :filename => "#{entry.unique_hash}-#{entry.category.slug}-#{image_number}#{File.extname(image.original_filename)}",
      :original_filename => image.original_filename,
      :location => upload_dir,
      :entry => entry,
      :unique_hash => SecureRandom.hex,
      :number => image_number.to_i
    )

    i.validate!
    if i.errors.empty?
      i.write_to_filesystem(image)

      magick = Magick::Image.read(i.path).first
      i.caption = magick.get_iptc_dataset(Magick::IPTC::Application::Caption)

      if i.caption.blank?
        i.delete
        return { :success => false, :error => 'No caption data was found. Please ensure that the caption has been set using Photoshop or Photo Mechanic.' }
      end
      i.save

      # Reduce quality
      magick.write(i.path) { self.quality = 50 }
      i.size = magick.filesize
      i.save

      # Create thumbnail
      FileUtils::mkdir_p "#{i.location}/thumbnails"
      magick.change_geometry!('80x80') do |cols, rows, img|
        img.resize!(cols,rows)
      end
      magick.write("#{i.location}/thumbnails/#{i.filename}") { self.quality = 50 }

      return { :success => true, :image => i }
    end
    return { :success => false, :image => i, :error => i.errors.messages[:filename] }
  end

  # Returns the filename extension of the image
  def extension
    File.extname(filename).downcase.gsub('.', '')
  end

  # The full path of the image on the filesystem
  def path
    "#{location}/#{filename}"
  end

  # The path to the image's thumbnail on the filesystem
  def thumbnail_path
    "#{location}/thumbnails/#{filename}"
  end
  
  # Returns a Public URL to the image
  def public_url
    "/images/contest/#{entry.contest.year}/#{entry.category.slug}/#{entry.unique_hash}/#{filename}"
  end

  def public_thumbnail_url
    "/images/contest/#{entry.contest.year}/#{entry.category.slug}/#{entry.unique_hash}/thumbnails/#{filename}"
  end

  # Used for the jQuery FileUpload plugin
  def to_hash
    {
      :name => filename,
      :size => size,
      :url => download_url,
      :thumbnailUrl => thumbnail_url,
      :deleteUrl => delete_url,
      :deleteType => "DELETE"
    }
  end

  def download_url
    Rails.application.routes.url_helpers.download_image_path(unique_hash)
  end

  def thumbnail_url
    Rails.application.routes.url_helpers.image_thumbnail_path(unique_hash)
  end

  def delete_url
    Rails.application.routes.url_helpers.delete_image_path(unique_hash)
  end

  # Deletes the image and its thumbnail, along with the database record
  def delete
    begin
      File.delete(path)
      File.delete(thumbnail_path)
    rescue
    end
    destroy!
  end

  # Ensures that there are no errors in the image before it is saved
  def validate!
    file_type = FileType.where('lower(extension) = ?', extension).first
    if file_type.blank? || !entry.category.category_type.file_types.include?(file_type)
      errors.add(:filename, "Unsupported filetype. The #{entry.category} category requires one of the following: #{entry.category.file_types}")
      return
    end
  end

  # Writes the image to the filesystem
  #
  # @param image [ActionDispatch::Http::UploadedFile] The image uploaded from the client.
  def write_to_filesystem(image)
    FileUtils::mkdir_p location
    f = File.open("#{location}/#{filename}", 'wb')
    f.write(image.read)
    f.close
  end
    
end
