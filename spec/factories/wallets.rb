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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wallet do
    credits_count 1
    credits_left 1
    total_bought '9.99'
    payments_count 1
    user_id 1
    factory :empty_wallet do
      credits_count 0
      credits_left 0
      total_bought 0
      payments_count 0
      user_id 1
    end
    factory :full_wallet do
      credits_count 10_000
      credits_left 10_000
      total_bought 10_000
      payments_count 100
      user_id 1
    end
  end
end
