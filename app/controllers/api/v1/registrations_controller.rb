class Api::V1::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token,
                     if: proc { |c| c.request.format == 'application/json' }

  before_action :configure_permitted_parameters

  respond_to :json

  def create
    build_resource(sign_up_params)
    if resource.save
      resource.confirm!
      sign_in resource

      resource_hash = {
        user_id: resource.id,
        email: resource.email,
        auth_token: resource.authentication_token,
        created_at: resource.created_at
      }

      render status: 200,
             json: { success: true,
                     info: 'Registered',
                     data: { user: resource_hash },
                     error_code: 0 }
    else
      render status: :unprocessable_entity,
             json: { success: false,
                     info: 'Registration failed',
                     data: {},
                     message: [resource.errors, params],
                     error_code: 210
                   }
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
  end
end
