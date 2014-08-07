require 'rails_helper'

RSpec.describe Country, :type => :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:country)).to be_valid
  end

  it 'should be invalid without a name' do
    expect(FactoryGirl.build(:country, :name => nil )).to be_invalid
  end

  it 'should be invalid without an iso code' do
    expect(FactoryGirl.build(:country, :iso => nil )).to be_invalid
  end
end