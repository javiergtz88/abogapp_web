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

class Message < ActiveRecord::Base
  belongs_to :user

  validates :sender, presence: true, length: { minimum: 3 }
  validates :message_text, presence: true
  validates :timestamp, presence: true, length: { minimum: 6 }
  validates :status, presence: true
  validates :msg_type, presence: true
end
