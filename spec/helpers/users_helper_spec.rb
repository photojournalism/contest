require 'digest'
require 'rails_helper'
require 'uri'

RSpec.describe UsersHelper, :type => :helper do
  describe 'methods' do
    let(:user) { FactoryGirl.create(:user) }

    describe 'gravatar_id_for' do
      it 'should return a valid gravatar id' do
        md5 = Digest::MD5.new
        md5 << user.email.downcase
        expect(helper.gravatar_id_for(user)).to eq(md5.hexdigest)
      end
    end

    describe 'gravatar_url_for' do
      it 'should return a valid url' do
        expect(helper.gravatar_url_for(user)).to match(/\A#{URI::regexp}\z/)
      end

      it 'should include the gravatar id' do
        expect(helper.gravatar_url_for(user)).to include(helper.gravatar_id_for(user))
      end
    end

    describe 'gravatar_for' do
      let(:gravatar1) { helper.gravatar_for(user) }
      let(:gravatar2) { helper.gravatar_for(user, 100, 'image') }
      it 'should include the gravatar url' do
        expect(gravatar1).to include(helper.gravatar_url_for(user))
      end

      it 'should update width' do
        expect(gravatar2).to include("width='100'")
      end

      it 'should update CSS class' do
        expect(gravatar2).to include("class='image'")
      end

      it 'should be an img tag' do
        expect(gravatar1).to match(/\<img.*\>/)
      end
    end
  end
end