require 'rails_helper'

describe 'Wallets API V1' do
  describe 'API routes' do
    it 'has an index route' do
      get '/api/v1/wallets/'
      # puts response.body
    end
    it 'has an buy_credits route' do
      post '/api/v1/wallets/buy_credits'
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

    it 'can view its wallet data' do
      get '/api/v1/wallets/', @user_params, @HEADER_DATA
      body = JSON.parse(response.body)
      # puts body

      expect(response.status).to eq 200
      expect(body['success']).to eq true
      expect(body['info']).to eq 'Api::V1::WalletsController#index'
      expect(body['message']).to eq ''
      expect(body['error_code']).to eq 0
    end

    it 'can buy credits' do
      [1000, 5000, 10_000].inject(0) do |accum, amount|
        PricePair.new(amount: amount, price: amount - 0.98).save
        accuma = accum + amount
        payment_params = { token: 'tok_test_visa_4242' }
        post '/api/v1/wallets/buy_credits', @user_params.merge(payment_params).merge(amount: amount).to_json, @HEADER_DATA
        body = JSON.parse(response.body)
        puts body

        accum += amount
        expect(response.status).to eq 200
        expect(body['success']).to eq true
        expect(body['info']).to eq 'Api::V1::WalletsController#buy_credits'
        expect(body['message']).to eq ''
        expect(body['data']['credits_left']).to eq accuma
        expect(body['error_code']).to eq 0
        accuma
      end
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

    it "can't view its wallet data" do
      get '/api/v1/wallets/', @user_params, @HEADER_DATA
      body = JSON.parse(response.body)
      # puts body

      expect(response.status).to eq 401
      expect(body['success']).to eq false
      expect(body['info']).to eq 'Api::V1::WalletsController#failure'
      expect(body['message']).to eq 'Login Failed'
      expect(body['error_code']).to eq 1
    end

    it "can't buy credits" do
      payment_params = { token: 'tok_test_visa_4242' }

      PricePair.new(amount: 5000, price:  10.98).save
      post '/api/v1/wallets/buy_credits', @user_params.merge(payment_params).merge(amount: 5000).to_json, @HEADER_DATA
      body = JSON.parse(response.body)
      # puts body

      expect(response.status).to eq 401
      expect(body['success']).to eq false
      expect(body['info']).to eq 'Api::V1::WalletsController#failure'
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

    it "can't buy credits" do
      payment_params = { token: 'tok_test_insufficient_funds' }

      PricePair.new(amount: 5000, price:  10.98).save
      post '/api/v1/wallets/buy_credits', @user_params.merge(payment_params).merge(amount: 5000).to_json, @HEADER_DATA
      body = JSON.parse(response.body)
      # puts body

      expect(response.status).to eq 400
      expect(body['success']).to eq false
      expect(body['info']).to eq 'Api::V1::WalletsController#failure'
      expect(body['message']).to match /El pago esta mal! (.*)/
      expect(body['error_code']).to eq 505
    end
  end
end
