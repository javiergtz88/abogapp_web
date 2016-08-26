# == Schema Information
#
# Table name: memberships
#
#  id              :integer          not null, primary key
#  m_type          :integer
#  total_bought    :integer
#  payments_count  :integer
#  expire_date     :datetime
#  last_payment_at :datetime
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe 'model methods' do
    before(:each) do
      @payment_params = { type: 'visa', number: '4417119669820331', expire_month: 11,
                          expire_year: 2018, cvv2: 325, first_name: 'Joe', last_name: 'Shopper' }
    end

    it 'has method upgrade' do
      user = FactoryGirl.create(:user)
      membership = FactoryGirl.create(:membership, user: user)
      # commented to not wait payment
      # expect(membership.upgrade(1, @payment_params)).to eq(true)
      # expect(membership.upgrade(2, @payment_params)).to eq(true)
    end

    it 'has method upgrade_to_premium' do
      user = FactoryGirl.create(:user)
      membership = FactoryGirl.create(:membership, user: user)
      expect(membership.upgrade_to_premium).to eq(true)
      expect(membership.m_type).to eq(1)
      expect(membership.total_bought).to eq(20.00)
      expect(membership.payments_count).to eq(1)
      expect(membership.expire_date.day).to eq((Time.now + (60 * 60 * 24 * 30)).day)
      expect(membership.expire_date.month).to eq((Time.now + (60 * 60 * 24 * 30)).month)
      expect(membership.expire_date.year).to eq((Time.now + (60 * 60 * 24 * 30)).year)
      expect(membership.last_payment_at.day).to eq(Time.now.day)
      expect(membership.last_payment_at.month).to eq(Time.now.month)
      expect(membership.last_payment_at.year).to eq(Time.now.year)
    end

    it 'has method upgrade_to_mipyme' do
      user = FactoryGirl.create(:user)
      membership = FactoryGirl.create(:membership, user: user)
      expect(membership.upgrade_to_mipyme).to eq(true)
      expect(membership.m_type).to eq(2)
      expect(membership.total_bought).to eq(40.00)
      expect(membership.payments_count).to eq(1)
      expect(membership.expire_date.day).to eq((Time.now + (60 * 60 * 24 * 30)).day)
      expect(membership.expire_date.month).to eq((Time.now + (60 * 60 * 24 * 30)).month)
      expect(membership.expire_date.year).to eq((Time.now + (60 * 60 * 24 * 30)).year)
      expect(membership.last_payment_at.day).to eq(Time.now.day)
      expect(membership.last_payment_at.month).to eq(Time.now.month)
      expect(membership.last_payment_at.year).to eq(Time.now.year)
    end

    it 'has method data_h' do
      user = FactoryGirl.create(:user)
      membership = FactoryGirl.create(:membership, user: user)
      expect(membership.data_h).to be_kind_of Hash
    end
  end
end
