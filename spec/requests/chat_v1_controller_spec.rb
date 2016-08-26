require 'rails_helper'

describe 'Chat API V1' do
  describe 'POST crear message JSON-API' do
    before(:each) do
      user = FactoryGirl.create(:confirmed_user)
      user.wallet.add_credits(100) # patch for posting a message
      params = { user: { email: user.email, password: user.password } }.to_json
      post 'api/v1/sessions.json', params, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'
      body = JSON.parse(response.body)
      user_token =  body['data']['user']['auth_token']
      @user_email = user.email
      @user_params = { user_email: @user_email, user_token: user_token }
      delete '/users/sign_out'
    end

    it 'debe crear un message si los datos son correctos' do
      message = FactoryGirl.build(:message)
      @user_params.merge!(message: message)
      post 'api/v1/messages/create.json', @user_params.to_json, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'
      # puts @user_params.to_json
      body = JSON.parse(response.body)
      puts @user_params, body

      expect(response.status).to eq 200
      expect(body['success']).to eq true
      expect(body['info']).to eq 'Api::V1::ChatcontrollerController#post_msg'
      expect(body['message']).to eq 'credits_left' => 97
      expect(body['error_code']).to eq 0
    end

    it 'debe crear un message (con caracteres especiales) si los datos son correctos' do
      message = FactoryGirl.build(:message)
      message.message_text = 'á@#öéíúùèà este es un mensajé con ácentós'
      @user_params.merge!(message: message)
      post 'api/v1/messages/create.json', @user_params.to_json, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'
      puts @user_params.to_json
      body = JSON.parse(response.body)
      puts @user_params, body

      expect(response.status).to eq 200
      expect(body['success']).to eq true
      expect(body['info']).to eq 'Api::V1::ChatcontrollerController#post_msg'
      expect(body['message']).to eq 'credits_left' => 97
      expect(body['error_code']).to eq 0
    end

    it 'debe regresar error cuando los datos son incorrectos' do
      message = FactoryGirl.build(:message)
      params =  { user_email: @user_email, user_token: 'tokeninvalido' }
      params.merge!(message: message)
      post 'api/v1/messages/create.json', params.to_json, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'

      body = JSON.parse(response.body)
      # puts params, body

      expect(response.status).to eq 401
      expect(body['success']).to eq false
      expect(body['info']).to eq 'Api::V1::ChatController#failure'
      expect(body['message']).to eq 'Login Failed'
      expect(body['error_code']).to eq 1
    end
  end

  describe 'no puede crear un mensaje si no hay creditos' do
    before(:each) do
      user = FactoryGirl.create(:confirmed_user)
      params = { user: { email: user.email, password: user.password } }.to_json
      post 'api/v1/sessions.json', params, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'
      body = JSON.parse(response.body)
      user_token =  body['data']['user']['auth_token']
      @user_email = user.email
      @user_params = { user_email: @user_email, user_token: user_token }
      delete '/users/sign_out'
    end

    it 'regresa error' do
      message = FactoryGirl.build(:message)
      @user_params.merge!(message: message)
      post 'api/v1/messages/create.json', @user_params.to_json, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'
      # puts @user_params.to_json
      body = JSON.parse(response.body)
      puts @user_params, body

      expect(response.status).to eq 422
      expect(body['success']).to eq false
      expect(body['info']).to eq 'Api::V1::ChatController#failure'
      expect(body['message']).to eq 'No hay creditos'
      expect(body['error_code']).to eq 303
    end
  end

  describe 'GET ultimos 20 mensajes JSON-API' do
    before(:each) do
      user = FactoryGirl.create(:confirmed_user)
      user_messages = FactoryGirl.create(:message, user: user)
      params = { user: { email: user.email, password: user.password } }.to_json
      post 'api/v1/sessions.json', params, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'
      body = JSON.parse(response.body)
      @user_token = body['data']['user']['auth_token']
      @user_email = user.email
      @user_params = { user_email: @user_email, user_token: @user_token }
      delete '/users/sign_out'
    end

    it 'debe poder bajar los mensajes si las credenciales son correctas' do
      get 'api/v1/messages/last20.json', @user_params, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

      body = JSON.parse(response.body)
      # puts @user_params, body

      expect(response.status).to eq 200
      expect(body['success']).to eq true
      expect(body['info']).to eq 'Api::V1::ChatcontrollerController#get_msgs'
      expect(body['message']).to eq ''
      expect(body['error_code']).to eq 0
    end

    it 'no debe poder bajar los mensajes si las credenciales son incorrectas' do
      params =  { user_email: @user_email, user_token: 'tokeninvalido' }
      get 'api/v1/messages/last20.json', params, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'

      body = JSON.parse(response.body)
      # puts params, body

      expect(response.status).to eq 401
      expect(body['success']).to eq false
      expect(body['info']).to eq 'Api::V1::ChatController#failure'
      expect(body['message']).to eq 'Login Failed'
      expect(body['error_code']).to eq 1
    end
  end
end
