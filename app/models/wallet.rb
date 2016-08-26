# == Schema Information
#
# Table name: wallets
#
#  id             :integer          not null, primary key
#  credits_count  :integer
#  credits_left   :integer
#  total_bought   :integer
#  payments_count :integer
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Wallet < ActiveRecord::Base
  belongs_to :user
  before_create :set_defaults

  attr_reader :payment_errors

  CREDIT_PRICE = 1.0

  def data_h
    { credits_left: credits_left }
  end

  def buy_credits(amount, payment_params)
    # if payment is aproved:
    # increase by amount credits_count, credits_left
    # increase by total of transaction total_bought
    # increase by one payments_count
    total = PricePair.find_by(amount: amount)
    fail 'wrong amount' if total.nil?

    payment = PaymentConekta.new
    if payment.do_payment(total.price, "Compra de #{amount} credito(s)", payment_params)
      add_credits(total.amount)
      self.total_bought += total.price
      self.payments_count += 1
      return true
    else
      @payment_errors = payment.errors
    end
    false
  end

  def pay_credits(amount)
    # if available, decrease by amount credits_left
    # if not available report error
    if (credits_left >= amount)
      self.credits_left -= amount
      return save
    end
    false
  end

  def add_credits(amount)
    # increase by amount credits_count, credits_left
    # initialize if not initialized
    self.credits_count ||= 0 if credits_count.nil?
    self.credits_left ||= 0 if self.credits_left.nil?
    # logic
    self.credits_count += amount
    self.credits_left += amount
    save
  end

  def enough_credits?(amount)
    self.credits_left >= amount
  end

  private

  def set_defaults
    self.total_bought = 0.00
    self.payments_count = 0
    self.credits_left = 0
  end
end
