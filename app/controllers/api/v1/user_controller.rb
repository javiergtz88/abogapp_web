require 'api/v1/api_v1_controller'

class Api::V1::UserController < Api::V1::ApiController
  load_and_authorize_resource :user
  skip_authorize_resource :user, only: :android_fb_create

  # GET /user/:id.json
  def show
    user = current_user
    datos_usuario = current_user.userdata
    user_hash = {
      email:    user.email,
      name:     datos_usuario.nombre,
      lastname: datos_usuario.apellido,
      type:     datos_usuario.tipo,
      city:     datos_usuario.city,
      state:    datos_usuario.state
    }
    success({ user: user_hash }, info: 'Api::V1::UserController#show', message: '')
  end

  # POST /user/:id.json
  def update
    user = User.where(email: params[:user_email], authentication_token: params[:user_token]).take

    user.build_userdata if user.userdata.nil?

    if user.userdata.update_attributes(allowed_params)
      success({ user: user.userdata }, info: 'Api::V1::UserController#update', message: '')
    else
      failure 500, info: 'Api::V1::UserController'
    end
  end

  def android_fb_create
    user = User.from_android_fb_auth(allowed_android_fb_auth_params)
    if user
      success(user, info: 'Api::V1::UserController#android_fb_create', message: '')
    else
      failure(500, info: 'Api::V1::UserController', message: "#{user.errors}")
    end
  end

  private

  def allowed_params
    params.require(:user_data).permit(:nombre, :apellido, :city, :state)
  end

  def allowed_android_fb_auth_params
    params.require(:user_data).permit(:access_token, :user_id)
  end
end
