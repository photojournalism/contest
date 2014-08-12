require 'fileutils'
require 'rmagick'

class Image < ActiveRecord::Base
  validates_presence_of :filename, :original_filename, :size, :location, :entry, :unique_hash

  belongs_to :entry

  def self.upload(image, entry)
    upload_dir = "app/assets/images/contest/#{entry.contest.year}/#{entry.category.slug}/#{entry.uuid}"
    i = Image.new(
      :filename => image.original_filename,
      :original_filename => image.original_filename,
      :location => upload_dir,
      :entry => entry,
      :unique_hash => SecureRandom.hex,
      :size => 0
    )

    i.validate!
    if i.errors.empty?
      FileUtils::mkdir_p upload_dir
      f = File.open("#{i.location}/#{i.filename}",'wb')
      f.write(image.read)
      i.size = f.size

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
    File.extname(filename)
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
    "/assets/contest/#{entry.contest.year}/#{entry.category.slug}/#{entry.uuid}/#{filename}"
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

  def validate!
    file_type = FileType.where('lower(extension) = ?', extension.downcase.gsub('.', '')).first
    if !file_type
      errors.add(:filename, "Unsupported filetype. The #{entry.category} category requires one of the following: #{entry.category.file_types}")
      return
    end

    if !entry.category.category_type.file_types.include? file_type
      errors.add(:filename, "Unsupported filetype for the #{entry.category} category.")
      return
    end
  end
end
