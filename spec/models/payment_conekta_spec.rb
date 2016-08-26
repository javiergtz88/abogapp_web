require 'rails_helper'

RSpec.describe PaymentConekta, type: :model do
  it 'can be initialized with correct parameters' do
    payment_params = { token: 'tok_test_visa_4242' }
    payment = PaymentConekta.new
    expect(payment.do_payment(10, 'a description', payment_params)).not_to be(false)
  end

  describe "payment can't be initialized with incorrect parameters" do
    it 'has total missing' do
      payment_params = { token: 'tok_test_visa_4242' }
      payment = PaymentConekta.new
      expect(payment.do_payment('a description', payment_params)).to be(false)
      expect(payment.errors).to eq(['invalid_payment_type'])
    end

    it 'has description missing' do
      payment_params = { token: 'tok_test_visa_4242' }
      payment = PaymentConekta.new
      expect(payment.do_payment(10, payment_params)).to be(false)
      expect(payment.errors).to eq(['invalid_payment_type'])
    end

    # it "has the card declined" do
    #  payment_params = {conektaTokenId: "tok_test_card_declined"}
    #  payment= PaymentConekta.new
    #  expect(payment.do_payment(10, "a description",payment_params)).to be(false)
    # expect(payment.errors).to eq([''])
    # end

    it 'has the card with insufficient funds' do
      payment_params = { token: 'tok_test_insufficient_funds' }
      payment = PaymentConekta.new
      expect(payment.do_payment(10, 'a description', payment_params)).to be(false)
      expect(payment.errors).to eq(['processing_error'])
    end
  end
end
