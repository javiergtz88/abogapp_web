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

class PricePair < ActiveRecord::Base
  validates :amount, presence: true
  validates :amount, uniqueness: true
  validates :price, presence: true
end
