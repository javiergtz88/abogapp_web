require 'api/v1/api_v1_controller'

class Api::V1::MembershipsController < Api::V1::ApiController
  load_and_authorize_resource :user

  def index
    return failure(401, message: 'Login Failed', info: 'Api::V1::MembershipsController#failure') unless current_user
    @membership = current_user.membership
    begin
      success @membership.data_h, info: 'Api::V1::MembershipsController#index'
    rescue
      return failure(400, message: "#{$ERROR_INFO}", info: 'Api::V1::MembershipsController#failure')
    end
  end

  def upgrade
    return failure(401, message: 'Login Failed', info: 'Api::V1::MembershipsController#failure') unless current_user
    @membership = current_user.membership
    begin
      if @membership.upgrade 1, params
        success @membership.data_h, info: 'Api::V1::MembershipsController#upgrade'
      else
        return failure(400, message: 'El pago esta mal!', info: 'Api::V1::MembershipsController#failure', error_code: 505)
      end
    rescue
      return failure(400, message: "#{$ERROR_INFO}", info: 'Api::V1::MembershipsController#failure', error_code: 505)
    end
  end
end
