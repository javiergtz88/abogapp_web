# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  authentication_token   :string(255)
#  confirmed_at           :datetime
#  confirmation_token     :string(255)
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  name                   :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:confirmed_user)).to be_valid
  end

  it 'return the las 20 messages' do
    user = FactoryGirl.create(:confirmed_user)
    message = FactoryGirl.create(:message, user: user)
    expect(user.last_20_messages).to eq [message]
  end

  it 'return users_with_messages_pending' do
    user = FactoryGirl.create(:confirmed_user)
    message = FactoryGirl.create(:message, user: user)
    User.users_with_messages_pending
  end
end
