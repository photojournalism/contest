require 'rails_helper'
require 'fileutils'

RSpec.describe ImagesController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }
  before(:all) do
    f = File.open("spec/fixtures/files/rails.jpg", "rb")
    f_new = File.open("spec/fixtures/files/rails_new.jpg", "wb")
    f_thumb = File.open("spec/fixtures/files/thumbnails/rails_new.jpg", "wb")
    f_new.write(f.read)
    f_thumb.write(f.read)
    f.close
    f_new.close
    f_thumb.close
  end

  after(:all) do
    FileUtils.rm_rf('public/images/contest/2014/first-category')
  end

  describe 'POST upload' do
    let(:entry) { FactoryGirl.create(:entry) }
    let(:file_type) { FactoryGirl.create(:file_type) }
    before(:each) do
      entry.category.category_type.file_types << file_type
    end

    it 'should not upload an image without an underscore and two numbers' do
      file = fixture_file_upload('files/rails.jpg')
      sign_in user
      post :upload, :entry => entry.id, :files => [file]
      expect(response.body).to include('Image filename must end with underscore, then two-digit number')
    end

    it 'should not upload an image without the correct filetype' do
      file = fixture_file_upload('files/rails_01.png')
      sign_in user
      post :upload, :entry => entry.id, :files => [file]
      expect(response.body).to include('Unsupported filetype')
    end

    it 'should not upload image without caption data' do
      file = fixture_file_upload('files/rails_no_caption_01.jpg')
      sign_in user
      post :upload, :entry => entry.id, :files => [file]
      expect(response.body).to include('No caption')
    end

    it 'should upload image with valid filetype and with caption data' do
      file = fixture_file_upload('files/rails_caption_01.jpg')
      sign_in user
      post :upload, :entry => entry.id, :files => [file]
      expect(response.body).to include(entry.unique_hash)
    end

    it 'should save a valid image' do
      file = fixture_file_upload('files/rails_caption_01.jpg')
      sign_in user
      expect {
        post :upload, :entry => entry.id, :files => [file]
      }.to change(Image, :count).by(1)
    end

    it 'should redirect if the user is not logged in' do
      file = fixture_file_upload('files/rails_01.png')
      post :upload, :entry => entry.id, :files => [file]
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should not upload if the filetype does not exist in the category' do
      file_type.category_types = []
      file_type.save
      sign_in user

      file = fixture_file_upload('files/rails_caption_01.jpg')
      post :upload, :entry => entry.id, :files => [file]
      expect(response.body).to include('Unsupported filetype')
    end
  end

  describe 'GET download' do
    let(:image) { FactoryGirl.create(:image) }

    it 'should redirect if the user is not logged in' do
      get :download, :hash => image.unique_hash
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should download if the user is logged in' do
      sign_in user
      get :download, :hash => image.unique_hash
      f = File.open(image.path, 'rb')
      expect(response.body).to eq( f.read )
    end
  end

  describe 'GET thumbnail' do
    let(:image) { FactoryGirl.create(:image) }

    it 'should redirect if the user is not logged in' do
      get :thumbnail, :hash => image.unique_hash
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should download if the user is logged in' do
      sign_in user
      get :thumbnail, :hash => image.unique_hash
      f = File.open(image.thumbnail_path, 'rb')
      expect(response.body).to eq( f.read )
    end
  end

  describe 'GET for_entry' do
    let(:entry) { FactoryGirl.create(:entry, :user => user) }
    
    it 'should list the image if it belongs to the entry and user' do
      image = FactoryGirl.create(:image, :entry => entry)
      sign_in user
      get :for_entry, :hash => entry.unique_hash
      expect(response.body).to include(image.filename)
    end

    it 'should list the image if it belongs to the entry and not the user, but user is admin' do
      image = FactoryGirl.create(:image, :entry => entry)
      entry = FactoryGirl.create(:entry)
      user.admin = true
      user.save

      sign_in user
      get :for_entry, :hash => entry.unique_hash
      expect(response.body).to include(image.filename)
    end

    it 'should be empty if the entry has no images' do
      sign_in user
      get :for_entry, :hash => entry.unique_hash
      expect(response.body).to eq({ :files => [] }.to_json)
    end

    it 'should redirect if the user is not logged in' do
      get :for_entry, :hash => entry.unique_hash
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should be empty if the entry has no user' do
      entry = FactoryGirl.create(:entry)
      sign_in user
      get :for_entry, :hash => entry.unique_hash
      expect(response.body).to eq(" ")
    end
  end

  describe 'DELETE destroy' do
    let(:entry) { FactoryGirl.create(:entry, :user => user) }
    
    it 'should delete the image if it belongs to the user' do
      sign_in user
      image = FactoryGirl.create(:image, :entry => entry)
      
      expect {
        delete :destroy, :hash => image.unique_hash
      }.to change(Image, :count).by(-1)
    end

    it 'should delete the image if the user is an admin' do
      image = FactoryGirl.create(:image)
      sign_in user
      user.admin = true
      user.save

      expect {
        delete :destroy, :hash => image.unique_hash
      }.to change(Image, :count).by(-1)
    end

    it 'should not delete the image if the user is not an admin and the image does not belong to them' do
      image = FactoryGirl.create(:image)
      sign_in user

      expect {
        delete :destroy, :hash => image.unique_hash
      }.to change(Image, :count).by(0)
    end

    it 'should not delete the image if the user is not signed in' do
      image = FactoryGirl.create(:image)
      expect {
        delete :destroy, :hash => image.unique_hash
      }.to change(Image, :count).by(0)
    end

    it 'should redirect if the user is not logged in' do
      get :for_entry, :hash => entry.unique_hash
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should delete the image from the filesystem' do
      image = FactoryGirl.create(:image)
      sign_in user
      delete :destroy, :hash => image.unique_hash
      expect(File.exist? image.path).to eq(false)
    end

    it 'should delete the image thumbnail from the filesystem' do
      image = FactoryGirl.create(:image)
      sign_in user
      delete :destroy, :hash => image.unique_hash
      expect(File.exist? image.thumbnail_path).to eq(false)
    end
  end
end
