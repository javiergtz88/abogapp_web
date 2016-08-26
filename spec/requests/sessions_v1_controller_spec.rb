require 'rails_helper'

describe 'Session API V1' do
  describe 'POST inicio de sesion del usuario JSON-API' do
    before(:each) do
      @user = FactoryGirl.create(:confirmed_user)
    end

    it 'debe regresar el token si los datos son correctos' do
      params = "{\"user\":{\"email\":\"#{@user.email}\",\"password\":\"#{@user.password}\"}}"
      post 'api/v1/sessions.json', params, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'

      body = JSON.parse(response.body)
      # puts params, body

      expect(response.status).to eq 200
      expect(body['success']).to eq true
      expect(body['info']).to eq 'Api::V1::SessionsController - create'
    end

    it 'debe regresar error cuando los datos son incorrectos' do
      params = "{\"user\":{\"email\":\"#{@user.email}\", \"password\":\"contraseñainvalida\"}}"
      post 'api/v1/sessions.json', params, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'

      body = JSON.parse(response.body)
      # puts params, body

      expect(response.status).to eq 401
      expect(body['info']).to eq 'Login Failed'
    end
  end

  describe 'DELETE destruir la sesion del usuario JSON-API' do
    before(:each) do
      user = FactoryGirl.create(:confirmed_user)
      params = { user: { email: user.email, password: user.password } }.to_json
      post 'api/v1/sessions.json', params, 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'
      body = JSON.parse(response.body)
      @user_token = body['data']['user']['auth_token']
      @user_email = user.email
      @user_params = { user_email: @user_email, user_token: @user_token }
      delete '/users/sign_out'
      @request_headers = {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
    end

    it 'debe destruir la session' do
      delete 'api/v1/sessions.json', @user_params.to_json, @request_headers
      body = JSON.parse(response.body)
      # puts body
      expect(response.status).to eq 200
    end

    it 'no debe destruir la session con token incorrecto' do
      params = { user_email: @user_email, auth_token: 'tokenincorrecto' }
      delete 'api/v1/sessions.json', params.to_json, @request_headers
      body = JSON.parse(response.body)
      # puts body
      expect(response.status).to eq 401
    end
  end

  describe 'POST registro de un usuario JSON-API' do
    before(:each) do
      @user = FactoryGirl.build(:user)
      @request_headers = {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      }
    end

    it 'debe registrar el suario y regresar el token si los datos son correctos' do
      params = { user:
        {
          email: @user.email,
          password: @user.password,
          password_confirmation: @user.password_confirmation
        }
      }.to_json
      post 'api/v1/registrations.json', params, @request_headers

      body = JSON.parse(response.body)
      expect(response.status).to eq 200
    end

    it 'debe regresar error cuando los datos son incorrectos' do
      params = { user:
        {
          email: @user.email,
          password: @user.password,
          password_confirmation: 'invalidpassword'
        }
      }.to_json
      post 'api/v1/registrations.json', params, @request_headers

      body = JSON.parse(response.body)

      expect(response.status).to eq 422
      expect(body['info']).to eq 'Registration failed'
    end

    it 'must be able to update its data after registration' do
      params = { user:
        {
          email: @user.email,
          password: @user.password,
          password_confirmation: @user.password_confirmation
        }
      }.to_json
      post 'api/v1/registrations.json', params, @request_headers
      body = JSON.parse(response.body)
      expect(response.status).to eq 200

      user_data = FactoryGirl.build(:userdatum)
      a_token = body['data']['user']['auth_token']
      a_id = body['data']['user']['user_id']
      params2 = { user_email: @user.email, user_token: a_token,
                  user_data: user_data }.to_json
      post "api/v1/users/#{a_id}.json", params2, @request_headers
      # puts body = JSON.parse(response.body)
      expect(response.status).to eq 200
    end
  end
end
