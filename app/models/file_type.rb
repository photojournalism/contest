class FileType < ActiveRecord::Base
  validates_presence_of :name, :extension
  has_and_belongs_to_many :category_types

  def to_s
    extension
  end
end
