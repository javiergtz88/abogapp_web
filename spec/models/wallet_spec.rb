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

require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'method buy_credits' do
    it 'buy credits if valid params' do
      payment_params = { token: 'tok_test_visa_4242' }
      wallet = FactoryGirl.create(:empty_wallet)

      PricePair.new(amount: 1000, price: 5.99).save
      expect(wallet.buy_credits(1000, payment_params)).to be(true)
    end
  end

  describe 'method pay_credits' do
    it 'pays credits' do
      wallet = FactoryGirl.create(:empty_wallet)
      expect(wallet.pay_credits(3)).to be(false)
      wallet.add_credits(3)
      expect(wallet.pay_credits(3)).to be(true)
      expect(wallet.credits_count).to be(3)
      expect(wallet.credits_left).to be(0)
    end
  end

  describe 'method add_credits' do
    it 'adds credits' do
      wallet = FactoryGirl.create(:empty_wallet)
      wallet.add_credits(3)
      expect(wallet.credits_count).to be(3)
      expect(wallet.credits_left).to be(3)
      wallet.add_credits(3)
      expect(wallet.credits_count).to be(6)
      expect(wallet.credits_left).to be(6)
    end
  end

  it 'has method data_h' do
    wallet = FactoryGirl.create(:empty_wallet)
    wallet.data_h
  end
end
