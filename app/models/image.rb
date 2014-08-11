class Image < ActiveRecord::Base
  validates_presence_of :filename, :original_filename, :size, :location, :entry

  belongs_to :entry

  UPLOAD_DIR = "data"

  def self.upload(image)
    i = Image.new(
      :filename => image.filename,
      :original_filename => image.original_filename,
      :location => "#{UPLOAD_DIR}/#{current_user.email}"
    )

    `mkdir -p #{UPLOAD_DIR}/#{current_user.email}`
    f = File.open("#{i.location}/#{i.filename}",'wb')
    f.write(image.read)
  end
end
