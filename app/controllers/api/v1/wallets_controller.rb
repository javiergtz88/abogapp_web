require 'api/v1/api_v1_controller'

class Api::V1::WalletsController < Api::V1::ApiController
  load_and_authorize_resource :user

  def index
    return failure(401, message: 'Login Failed', info: 'Api::V1::WalletsController#failure') unless current_user
    @wallet = current_user.wallet
    begin
      success @wallet.data_h, info: 'Api::V1::WalletsController#index'
    rescue
      return failure(400, message: "#{$ERROR_INFO}", info: 'Api::V1::WalletsController#failure')
    end
  end

  def buy_credits
    return failure(401, message: 'Login Failed', info: 'Api::V1::WalletsController#failure') unless current_user
    @wallet = current_user.wallet
    begin
      if @wallet.buy_credits(payment_params[:amount], payment_params)
        success @wallet.data_h, info: 'Api::V1::WalletsController#buy_credits'
      else
        return failure(400, message: "El pago esta mal! #{@wallet.payment_errors}", info: 'Api::V1::WalletsController#failure', error_code: 505)
      end
    rescue
      return failure(400, message: "#{$ERROR_INFO}", info: 'Api::V1::WalletsController#failure', error_code: 505)
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_params
    params.permit(:amount, :token, :user_email, :first_name, :user_phone)
  end
end
