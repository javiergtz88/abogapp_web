# == Schema Information
#
# Table name: price_pairs
#
#  id         :integer          not null, primary key
#  amount     :integer
#  price      :decimal(16, 2)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :price_pair do
  end
end
