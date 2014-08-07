require 'rails_helper'

RSpec.describe FileType, :type => :model do
  describe 'validation' do
    let(:file_type) { FactoryGirl.build(:file_type) }

    it 'has a valid factory' do
      expect(file_type).to be_valid
    end

    it 'should be invalid without a name' do
      file_type.name = nil
      expect(file_type).to be_invalid
    end

    it 'should be invalid without an extension' do
      file_type.extension = nil
      expect(file_type).to be_invalid
    end
  end
end
