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
      # Write to filesystem
      i.write_to_filesystem(image)

      # Get caption data
      exif = EXIFR::JPEG.new(i.path)
      i.caption = "#{exif.image_description.to_s}".force_encoding("utf-8")

      if i.caption.blank?
        i.delete
        return { :success => false, :error => 'No caption data was found. Please ensure that the caption has been set using Photoshop or Photo Mechanic.' }
      end
      i.save

      # Reduce quality to 50%
      i.reduce_quality(50)
      i.create_thumbnail
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

  # Used for the jQuery FileUpload plugin
  def to_hash
    {
      :name => filename,
      :size => size,
      :url => "/images/download/#{unique_hash}",
      :thumbnailUrl => "/images/thumbnail/#{unique_hash}",
      :deleteUrl => "/images/#{unique_hash}",
      :deleteType => "DELETE"
    }
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

  # Writes the image's thumbnail to the filesystem at 80x80 and 50% quality
  def create_thumbnail
    FileUtils::mkdir_p "#{location}/thumbnails"
    image = Magick::Image.read(path).first
    image.change_geometry!('80x80') do |cols, rows, img|
      img.resize!(cols,rows)
    end
    image.write("#{location}/thumbnails/#{filename}") { self.quality = 50 }
  end

  # Reduces the quality of the image
  #
  # @param quality [Integer] The percent quality to be reduced to.
  def reduce_quality(quality)
    image = Magick::Image::read(path).first
    image.write(path) { self.quality = quality }
    self.size = image.filesize
    self.save
    image.destroy!
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
