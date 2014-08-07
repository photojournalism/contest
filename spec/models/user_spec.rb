require 'rails_helper'

describe 'User' do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:user)).to be_valid
  end

  it 'should be invalid without an email' do
    expect(FactoryGirl.build(:user, :email => nil )).to be_invalid
  end

  it 'should be invalid without a first name' do
    expect(FactoryGirl.build(:user, :first_name => nil )).to be_invalid
  end

  it 'should be invalid without a last name' do
    expect(FactoryGirl.build(:user, :last_name => nil )).to be_invalid
  end
  it 'should be invalid without a street' do
    expect(FactoryGirl.build(:user, :street => nil )).to be_invalid
  end
  it 'should be invalid without a city' do
    expect(FactoryGirl.build(:user, :city => nil )).to be_invalid
  end
  it 'should be invalid without a state' do
    expect(FactoryGirl.build(:user, :state_id => nil )).to be_invalid
  end

  it 'should be invalid without a day phone' do
    expect(FactoryGirl.build(:user, :day_phone => nil )).to be_invalid
  end 

  it 'should be invalid without a evening phone' do
    expect(FactoryGirl.build(:user, :evening_phone => nil )).to be_invalid
  end

  describe 'full_name' do
    it "should return the user's full name" do
      user = FactoryGirl.build(:user)
      expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
    end
  end
end