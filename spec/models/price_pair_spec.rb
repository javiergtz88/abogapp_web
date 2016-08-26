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

require 'rails_helper'

RSpec.describe PricePair, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
