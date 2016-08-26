require 'api/v1/api_v1_controller'

class Api::V1::ChatController < Api::V1::ApiController
  load_and_authorize_resource :user
  load_and_authorize_resource :message, through: :user

  def post_msg
    return failure(401, message: 'Login Failed', info: 'Api::V1::ChatController#failure') unless current_user
    begin
      @mensaje = current_user.messages.build(allowed_params)
      @wallet = current_user.wallet
      if @wallet.enough_credits?(@mensaje.priority)
        if @mensaje.save
          # after the message is saved the creadits are payed to avoid charge without a message save.
          @wallet.pay_credits(@mensaje.priority)
          success({}, info: 'Api::V1::ChatcontrollerController#post_msg', message: @wallet.data_h)
        else
          failure 500, message: "No se pudo guardar en la bd: #{$ERROR_INFO}"
        end
      else
        failure 422, message: 'No hay creditos', info: 'Api::V1::ChatController#failure', error_code: 303
      end
    rescue
      failure 500, "#{$ERROR_INFO}"
    end
  end

  def get_msgs
    return failure(401, message: 'Login Failed', info: 'Api::V1::ChatController#failure') unless current_user
    begin
       @user_messages = current_user.last_20_messages
       success({ messages: @user_messages }, info: 'Api::V1::ChatcontrollerController#get_msgs')
     rescue
       failure 500, "#{$ERROR_INFO}"
     end
  end

  private

  def allowed_params
    params.require(:message).permit(:id_mensaje, :msg_type, :recipient,
                                    :sender, :status, :message_text, :timestamp, :priority)
  end
end
