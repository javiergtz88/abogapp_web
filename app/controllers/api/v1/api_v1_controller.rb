class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session, if: proc { |c| c.request.format == 'application/json' }
  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  respond_to :json

  # Apply strong_parameters filtering before CanCan authorization
  # See https://github.com/ryanb/cancan/issues/571#issuecomment-10753675
  before_action do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def failure(status = 500, params)
    render status: status,
           json: {
             success: false,
             info: params[:info] || 'Api::V1::#failure',
             data: params[:data] || {},
             message: params[:message] || '',
             error_code: params[:error_code] || 1
           }
  end

  def success(data = {}, params)
    render status: 200,
           json: {
             success: true,
             info: params[:info] || '',
             data: data,
             message: params[:message] || '',
             error_code: params[:error_code] || 0
           }
  end
end
