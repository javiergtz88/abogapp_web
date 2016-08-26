# == Schema Information
#
# Table name: userdata
#
#  id         :integer          not null, primary key
#  nombre     :string(255)
#  apellido   :string(255)
#  tipo       :integer
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  city       :string(255)
#  state      :string(255)
#

require 'rails_helper'

RSpec.describe Userdata, type: :model do
  describe 'model attributes' do
    before(:each) do
      @user_data = FactoryGirl.create(:userdatum)
    end

    it { expect(@user_data).to respond_to 'nombre' }
    it { expect(@user_data).to respond_to 'apellido' }
    it { expect(@user_data).to respond_to 'city' }
    it { expect(@user_data).to respond_to 'state' }
  end
end
