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

class Userdata < ActiveRecord::Base
  belongs_to :user
end
