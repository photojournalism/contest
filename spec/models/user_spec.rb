require 'rails_helper'

describe 'User' do

  describe "validation" do
    let(:user) { FactoryGirl.build(:user) }

    it 'has a valid factory' do
      expect(user).to be_valid
    end
    
    it 'should be invalid without an email' do
      user.email = nil
      expect(user).to be_invalid
    end

    it 'should be invalid without a first name' do
      user.first_name = nil
      expect(user).to be_invalid
    end

    it 'should be invalid without a last name' do
      user.last_name = nil
      expect(user).to be_invalid
    end
    it 'should be invalid without a street' do
      user.street = nil
      expect(user).to be_invalid
    end
    it 'should be invalid without a city' do
      user.city = nil
      expect(user).to be_invalid
    end
    it 'should be invalid without a state' do
      user.state = nil
      expect(user).to be_invalid
    end

    it 'should be invalid without a day phone' do
      user.day_phone = nil
      expect(user).to be_invalid
    end 

    it 'should be invalid without a evening phone' do
      user.evening_phone = nil
      expect(user).to be_invalid
    end

    it 'should respond to country' do
      expect(user).to respond_to(:country)
    end
  end

  describe 'methods' do
    let(:user) { FactoryGirl.build(:user) }

    describe 'full_name' do
      it "should return the user's full name" do
        expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
      end
    end

    describe 'address' do
      it 'should respond to address' do
        expect(user).to respond_to(:address)
      end

      it 'should return a valid address' do
        expect(user.address).to include(user.street)
        expect(user.address).to include(user.city)
        expect(user.address).to include(user.zip.to_s)
        expect(user.address).to include(user.state.name)
      end
    end
  end
end