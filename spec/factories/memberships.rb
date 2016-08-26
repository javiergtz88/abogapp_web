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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership do
    m_type 0
    total_bought 0.00
    payments_count 0
    expire_date nil
    last_payment_at nil
    user_id 1
  end
end
