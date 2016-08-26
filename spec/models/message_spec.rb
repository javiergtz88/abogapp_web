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

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'model attributes' do
    before(:each) do
      @message = FactoryGirl.create(:message)
    end

    it { expect(@message).to respond_to 'msg_type' }
    it { expect(@message).to respond_to 'recipient' }
    it { expect(@message).to respond_to 'sender' }
    it { expect(@message).to respond_to 'status' }
    it { expect(@message).to respond_to 'message_text' }
    it { expect(@message).to respond_to 'timestamp' }
    it { expect(@message).to respond_to 'priority' }
  end
end
