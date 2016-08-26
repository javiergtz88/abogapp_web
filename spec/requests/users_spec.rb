require 'rails_helper'

RSpec.describe 'Users', type: :request do
  before(:each) do
    @user = FactoryGirl.create(:confirmed_user)
    params = { user: { email: @user.email, password: @user.password } }.to_json
    request_headers = {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
    post 'api/v1/sessions.json', params, request_headers
    body = JSON.parse(response.body)
    @user_token = body['data']['user']['auth_token']
  end

  describe 'POST /users/:id' do
    it 'updates user data' do
      user_data = FactoryGirl.build(:userdatum)

      params = { user_email: @user.email, user_token: @user_token,
                 user_data: user_data }.to_json

      request_headers = {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }

      post "api/v1/users/#{@user.id}.json", params, request_headers
      body = JSON.parse(response.body)
      expect(response.status).to eq 200
    end
  end

  describe 'GET /users/:id JSON-API' do
    it 'debe poder hacer get (con datousuario)' do
      user_data = FactoryGirl.create(:userdatum, user: @user)

      get "api/v1/users/#{@user.id}.json", { user_email: @user.email, user_token: @user_token }

      body = JSON.parse(response.body)
      expect(response.status).to eq 200
      expected_json = { email: @user.email,
                        name: nil,
                        lastname: nil,
                        type: nil,
                        city: nil,
                        state: nil
                      }.to_json
      expect(body['data']['user'].to_json).to eq expected_json
    end
  end

  describe 'POST /users/android/fb_create' do
    let(:request_headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }

    it 'new user from facebook' do
      params = { user_data: { access_token: 'CAAP28cVWAGMBAJt6w1XdKdTBdD6HxxboZCK3gneODZCtWMHAQcLNZBUaLSHLeS6tweeBcI6thRZAB8wujivm5HKE4ZBMQthvgXWTZBbGVSDUqYubBedzdGJM8Laq9Qhe1bpYSkNxV7WK4EfUeDNe8OrMKhfgo3JOiiiigt6Ff0vVDeFU2wmlw108ZCJVFVBi3vVxu6AgaLaccU1ofGbW3ZCyjwkPcwZCMZCWBkhDfjkFfzJgZDZD',
                              user_id: '10153657286935027' } }.to_json

      post 'api/v1/users/android/fb_create.json', params, request_headers
      body = JSON.parse(response.body)
      expect(response.status).to eq 200
    end
  end
end
