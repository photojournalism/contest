require 'fileutils'
require 'rmagick'
require 'exifr'

class Image < ActiveRecord::Base
  validates_presence_of :filename, :original_filename, :size, :location, :entry, :unique_hash, :caption, :number

  belongs_to :entry

  def self.delete_all
    Image.all.each do |image|
      image.delete
    end
  end

  def self.upload(image, entry)
    image_number = File.basename(image.original_filename, ".*")[-2..-1]
    if !(image_number =~ /\d\d/)
      return { :success => false, :error => "Image filename must end with underscore, then two-digit number. i.e., 'filename_01.jpg'"}
    end

    upload_dir = "#{Rails.root}/public/images/contest/#{entry.contest.year.to_s}/#{entry.category.slug}/#{entry.unique_hash}"
    i = Image.new(
      :filename => "#{entry.unique_hash}-#{entry.category.slug}-#{image_number}#{File.extname(image.original_filename)}",
      :original_filename => image.original_filename,
      :location => upload_dir,
      :entry => entry,
      :unique_hash => SecureRandom.hex,
      :size => 0,
      :number => image_number.to_i
    )

    i.validate!
    if i.errors.empty?
      # Write to filesystem
      FileUtils::mkdir_p upload_dir
      f = File.open("#{i.location}/#{i.filename}",'wb')
      f.write(image.read)
      f.close

      # Get caption data
      exif = EXIFR::JPEG.new(i.path)
      i.caption = "#{exif.image_description.to_s}".force_encoding("utf-8")

      if i.caption.blank?
        i.delete
        return { :success => false, :error => 'No caption data was found. Please ensure that the caption has been set using Photoshop or Photo Mechanic.' }
      end

      # Reduce quality
      image = Magick::Image::read(i.path).first
      image.write(i.path) { self.quality = 50 }
      i.size = image.filesize
      image.destroy!

      i.save
      i.create_thumbnail
      return { :success => true, :image => i }
    else
      return { :success => false, :image => i, :error => i.errors.messages[:filename] }
    end
    return false
  end

  def path
    "#{location}/#{filename}"
  end

  def extension
    File.extname(filename).downcase.gsub('.', '')
  end

  def create_thumbnail
    FileUtils::mkdir_p "#{location}/thumbnails"
    image = Magick::Image.read(path).first
    image.change_geometry!('80x80') do |cols, rows, img|
      img.resize!(cols,rows)
    end
    image.write("#{location}/thumbnails/#{filename}") { self.quality = 50 }
  end

  def thumbnail_path
    "#{location}/thumbnails/#{filename}"
  end
  
  def public_url
    "/assets/contest/#{entry.contest.year}/#{entry.category.slug}/#{entry.unique_hash}/#{filename}"
  end

  def to_hash
    return {
      :name => filename,
      :size => size,
      :url => "/images/download/#{unique_hash}",
      :thumbnailUrl => "/images/thumbnail/#{unique_hash}",
      :deleteUrl => "/images/#{unique_hash}",
      :deleteType => "DELETE"
    }
  end

  def delete
    begin
      File.delete(path)
      File.delete(thumbnail_path)
    rescue
    end
    destroy!
  end

  def validate!
    file_type = FileType.where('lower(extension) = ?', extension).first
    if file_type.blank?
      errors.add(:filename, "Unsupported filetype. The #{entry.category} category requires one of the following: #{entry.category.file_types}")
      return
    end

    if !entry.category.category_type.file_types.include? file_type
      errors.add(:filename, "Unsupported filetype for the #{entry.category} category.")
      return
    end
  end
end
