require 'rails_helper'

RSpec.describe State, :type => :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:state)).to be_valid
  end

  it 'should be invalid without a name' do
    expect(FactoryGirl.build(:state, :name => nil )).to be_invalid
  end

  it 'should be invalid without an iso code' do
    expect(FactoryGirl.build(:state, :iso => nil )).to be_invalid
  end

  it 'should be invalid without a country' do
    expect(FactoryGirl.build(:state, :country_id => nil )).to be_invalid
  end
end