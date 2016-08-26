# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  recipient    :string(255)
#  sender       :string(255)
#  status       :integer
#  message_text :text
#  timestamp    :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :integer
#  msg_type     :integer
#  priority     :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    msg_type 1
    recipient 'MyText'
    sender 'MyText'
    status 0
    message_text 'ejemplo de message_text'
    timestamp '2015-04-06 12:41:55'
    priority 3
  end
end
