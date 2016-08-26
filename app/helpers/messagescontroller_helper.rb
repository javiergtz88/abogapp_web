module MessagescontrollerHelper
  def status_string(number)
    ['no leido', 'leido'][number.to_i]
  end

  def msg_type_string(number)
    %w(default respuesta)[number.to_i]
  end

  def msg_type_options
    [['default', 0], ['respuesta', 1]]
  end
end
