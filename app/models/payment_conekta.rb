# require "conekta"

class PaymentConekta
  attr_reader :errors

  def initialize
    @errors = []
  end

  def do_payment(total = nil, description = nil, params = {})
    begin
      #user = User.where(email: params[:user_email]).take
      total *= 100 # ponerlo en centavos
      charge = Conekta::Charge.create('amount' => total,
                                      'currency' => 'MXN',
                                      'description' => description,
                                      'card' => params[:token], # "tok_a4Ff0dD2xYZZq82d9"
                                      'details' => {
                                        'name' => params[:first_name],
                                        'email' => params[:user_email],
                                        'phone' => params[:user_phone],
                                        'line_items' => line_items(description, total)
                                        }
                                      )

      return charge.status

    rescue Conekta::ParameterValidationError => e
      puts e.message_to_purchaser
      # alguno de los parámetros fueron inválidos
      @errors.push e.code

    rescue Conekta::ProcessingError => e
      puts e.message_to_purchaser
      # la tarjeta no pudo ser procesada
      @errors.push e.code

    rescue Conekta::Error => e
      puts e.message_to_purchaser
      # un error ocurrió que no sucede en el flujo normal de cobros como por ejemplo un auth_key incorrecto
      @errors.push e.code
    end

    false
  end

  def line_items description, total
    [{
      'name' => description,
      'description' => "Descripción de compra: #{description}. En la app appbogado.",
      'unit_price' => total,
      'quantity' => 1
    }]
  end

end
