require 'rails_helper'

describe 'Content Controller API V1' do
  describe 'API routes' do
    it 'has an index route' do
      get '/api/v1/contents/'
    end
    it 'has an search route' do
      post '/api/v1/contents/search'
    end
    it 'has an article route' do
      get '/api/v1/contents/article'
    end
  end

  describe 'retriving info with valid user' do
    before(:each) do
      @HEADER_DATA = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      user = FactoryGirl.create(:confirmed_user)
      params = { user: { email: user.email, password: user.password } }.to_json
      post 'api/v1/sessions.json', params, @HEADER_DATA
      body = JSON.parse(response.body)
      user_token =  body['data']['user']['auth_token']
      @user_email = user.email
      @user_params = { user_email: @user_email, user_token: user_token }
      delete '/users/sign_out'
    end

    it 'can get posts by index' do
      get '/api/v1/contents/', @user_params, @HEADER_DATA
      body = JSON.parse(response.body)
      puts body

      expect(response.status).to eq 200
      expect(body['success']).to eq true
      expect(body['info']).to eq 'Api::V1::ContentController#index'
      expect(body['message']).to eq ''
      expect(body['error_code']).to eq 0
    end

    it 'can get posts by search' do
      post '/api/v1/contents/search', @user_params.merge(search: 'New').to_json, @HEADER_DATA
      body = JSON.parse(response.body)
      puts body

      expect(response.status).to eq 200
      expect(body['success']).to eq true
      expect(body['info']).to eq 'Api::V1::ContentController#index'
      expect(body['message']).to eq ''
      expect(body['error_code']).to eq 0
    end

    it 'can get a post by id' do
      get '/api/v1/contents/article', @user_params.merge(id: 4), @HEADER_DATA
      body = JSON.parse(response.body)
      puts body

      expect(response.status).to eq 200
      expect(body['success']).to eq true
      expect(body['info']).to eq 'Api::V1::ContentController#index'
      expect(body['message']).to eq ''
      expect(body['error_code']).to eq 0
    end
  end
end
