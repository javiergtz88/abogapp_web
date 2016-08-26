require 'api/v1/api_v1_controller'

class Api::V1::SessionsController < Api::V1::ApiController
  load_and_authorize_resource :user
  skip_authorize_resource :user, only: :create

  def create
    resource = User.find_for_database_authentication(
      email: params[:user][:email]
    )
    return failure(401, info: 'Login Failed', error_code: 102) unless resource
    if resource.valid_password?(params[:user][:password])
      sign_in(:user, resource)
      success({ user: { user_id: resource.id, auth_token: resource.authentication_token,
                        email: resource.email } },
              info: 'Api::V1::SessionsController - create',
              message: t('devise.sessions.signed_in')
             )
      return
    end
    failure 401, info: 'Login Failed', error_code: 102
  rescue
    failure 401, message: "#{$ERROR_INFO}"
  end

  def destroy
    return failure(401, message: params) unless current_user
    current_user.update_column(:authentication_token, nil)
    render status: 200,
           json: { success: true,
                   info: 'Api::V1::SessionsController - destroy',
                   data: {},
                   message: t('devise.sessions.signed_out') }
  rescue
    failure 401, message: "#{$ERROR_INFO}"
  end
end
