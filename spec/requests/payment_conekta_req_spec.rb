require 'rails_helper'

describe 'Conekta API' do
  describe 'API routes' do
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
      user_token = body['data']['user']['auth_token']
      @user_email = user.email
      @user_params = { user_email: @user_email, user_token: user_token }
      delete '/users/sign_out'
    end

    it 'can make payment with tokens' do
      PricePair.new(amount: 5000, price:  10.98).save
      payment_params = { token: 'tok_test_visa_4242', first_name: 'Aquiles Castro', user_phone: '3333595920' }
      post '/api/v1/wallets/buy_credits', @user_params.merge(payment_params).merge(amount: 5000).to_json, @HEADER_DATA
      puts @user_params
      body = JSON.parse(response.body)
      puts body

      expect(response.status).to eq 200
    end
  end
end
