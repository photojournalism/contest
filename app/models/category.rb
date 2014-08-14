class Category < ActiveRecord::Base
  validates_presence_of :name, :description, :active, :category_type

  belongs_to :category_type
  has_and_belongs_to_many :contests

  def file_types
    output = []
    category_type.file_types.each_with_index do |ft, i|
      output << ft.extension
    end
    output
  end

  def slug
    name.downcase.gsub(' ', '-').gsub('/', '-')
  end

  def to_s
    name
  end
end
