require 'rails_helper'

describe 'Memberships API V1' do
  describe 'API routes' do
    it 'has an index route' do
      get '/api/v1/memberships/'
      # puts response.body
    end
    it 'has an upgrade route' do
      post '/api/v1/memberships/upgrade'
      # puts response.body
    end
  end

  describe 'happy paths with valid user' do
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

    it 'can view its data' do
      get '/api/v1/memberships/', @user_params, @HEADER_DATA
      body = JSON.parse(response.body)
      # puts body

      expect(response.status).to eq 200
      expect(body['success']).to eq true
      expect(body['info']).to eq 'Api::V1::MembershipsController#index'
      expect(body['message']).to eq ''
      expect(body['error_code']).to eq 0
    end
    it 'can upgrade its membership' do
      payment_params = { type: 'visa', number: '4417119669820331', expire_month: 11,
                         expire_year: 2018, cvv2: 325, first_name: 'Joe', last_name: 'Shopper' }
      post '/api/v1/memberships/upgrade', @user_params.merge(payment_params).to_json, @HEADER_DATA
      body = JSON.parse(response.body)
      puts body

      expect(response.status).to eq 200
      expect(body['success']).to eq true
      expect(body['info']).to eq 'Api::V1::MembershipsController#upgrade'
      expect(body['message']).to eq ''
      expect(body['data']['m_type']).to eq 1
      expect(body['error_code']).to eq 0
    end
  end

  describe 'happy paths with invalid user' do
    before(:each) do
      @HEADER_DATA = { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      user = FactoryGirl.create(:confirmed_user)
      params = { user: { email: user.email, password: user.password } }.to_json
      post 'api/v1/sessions.json', params, @HEADER_DATA
      body = JSON.parse(response.body)
      user_token =  body['data']['user']['auth_token']
      @user_email = user.email
      @user_params = { user_email: @user_email, user_token: 'invalid_token' }
      delete '/users/sign_out'
    end

    it "can't view its data" do
      get '/api/v1/memberships/', @user_params, @HEADER_DATA
      body = JSON.parse(response.body)
      # puts body

      expect(response.status).to eq 401
      expect(body['success']).to eq false
      expect(body['info']).to eq 'Api::V1::MembershipsController#failure'
      expect(body['message']).to eq 'Login Failed'
      expect(body['error_code']).to eq 1
    end
    it "can't upgrade its membership" do
      payment_params = { type: 'visa', number: '4417119669820331', expire_month: 11,
                         expire_year: 2018, cvv2: 325, first_name: 'Joe', last_name: 'Shopper' }
      post '/api/v1/memberships/upgrade', @user_params.merge(payment_params).to_json, @HEADER_DATA
      body = JSON.parse(response.body)
      # puts body

      expect(response.status).to eq 401
      expect(body['success']).to eq false
      expect(body['info']).to eq 'Api::V1::MembershipsController#failure'
      expect(body['message']).to eq 'Login Failed'
      expect(body['error_code']).to eq 1
    end
  end

  describe 'valid user with wrong payment data' do
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

    it "can't upgrade its membership" do
      # missing expire_year
      payment_params = { type: 'visa', number: '4417119669820331', expire_month: 11,
                         cvv2: 325, first_name: 'Joe', last_name: 'Shopper' }
      post '/api/v1/memberships/upgrade', @user_params.merge(payment_params).to_json, @HEADER_DATA
      body = JSON.parse(response.body)
      puts body

      expect(response.status).to eq 400
      expect(body['success']).to eq false
      expect(body['info']).to eq 'Api::V1::MembershipsController#failure'
      expect(body['message']).to eq 'missing expire_year'
      expect(body['error_code']).to eq 505
    end
  end
end
