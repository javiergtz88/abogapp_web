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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :userdatum, class: 'Userdata' do
    nombre 'MyString'
    apellido 'MyString'
    tipo 0
    city 'Guadalajara'
    state 'Jalisco'
  end
end
