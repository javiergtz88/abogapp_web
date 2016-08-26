class MessagesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @arreglo_usuarios = User.users_desc_priority
  end

  def index2
    @arreglo_usuarios = User.users_with_messages
  end

  def show
    # muestra los 20 messages mas recientes de un user_m ordenados por
    # status y segundamente por timestamp.
    @user = User.find(params[:usuario_id])
    @messages = @user.messages
    @mensaje_nuevo = @user.messages.build(
      status: 1,
      msg_type: 1
    )
  end

  def new
    # le agrega un Message a un usuario. El formulario puede estar en
    # otra ventana.
    @user = User.find(params[:usuario_id])
    @mensaje_nuevo = @user.messages.build(
      status: 1,
      msg_type: 1
    )
  end

  def create
    # le agrega un Message a un usuario.
    @user = User.find(params[:usuario_id])
    aditional_params = {
      recipient: @user.email,
      sender: current_admin.email,
      status: 1,
      priority: 0,
      timestamp: Time.now
    }
    @Message = @user.messages.build(allowed_params.merge(aditional_params))
    if @Message.save
      flash[:notice] = 'Message creado exitosamente!'
      redirect_to :back
    else
      flash[:notice] = "Error al crear Message! #{@Message.errors.full_messages}"
      redirect_to :back
    end
  end

  def edit
    # edita un Message en especifico
    @Message = Message.find(params[:msj_id])
  end

  def update
    # actualiza un Message en especifico
    @Message = Message.find(params[:msj_id])
    if @Message.update_attributes(allowed_params)
      flash[:notice] = 'Message actualizado exitosamente!'
      redirect_to :back
    else
      flash[:notice] = "Error al actualizar el Message! #{@Message.errors.full_messages}"
      redirect_to :back
    end
  end

  def read
    # actualiza un Message en especifico
    @Message = Message.find(params[:id])
    @Message.status = 1
    if @Message.save
      flash[:notice] = 'Message leido exitosamente!'
      redirect_to :back
    else
      flash[:notice] = "Error al leer el Message! #{@Message.errors.full_messages}"
      redirect_to :back
    end
  end

  def destroy
    @Message = Message.find(params[:id])
    @Message.destroy
    redirect_to :back
  end

  private

  def allowed_params
    params.require(:message).permit(:msg_type, :message_text)
   end
end
