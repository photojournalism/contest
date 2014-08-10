class CategoryType < ActiveRecord::Base
  validates_presence_of :name, :description, :minimum_files, :maximum_files
  validates :active,  :inclusion => {:in => [true, false]}
  validates :has_url, :inclusion => {:in => [true, false]}
  validate :maximum_files_is_greater_than_minimum_files

  def maximum_files_is_greater_than_minimum_files
    if minimum_files && maximum_files
      errors.add(:maximum_files, "Maximum files must be greater than minimum files") if maximum_files < minimum_files
    end
  end

  has_and_belongs_to_many :categories
  has_and_belongs_to_many :file_types
end
