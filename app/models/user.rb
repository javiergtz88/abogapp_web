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

class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :userdata
  has_one :wallet
  has_one :membership
  has_many :messages

  # after_create :initialize_user_data
  before_create :initialize_user_data, :initialize_wallet, :initialize_membership

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:facebook]

  def last_20_messages
    array_of_hashes = []
    user_messages = messages.last(20)
    # user_messages.each { |message| @array_of_hashes.push(message) }
  end

  def self.users_desc_priority
    usuarios = includes(:messages).where('messages.status = ?', 0).order('messages.priority DESC')
    usuarios.inject([]) do |ar, us|
      temp_hash = {
        email: us.email,
        usuario_id: us.id,
        mensaje: {  no_leidos: us.messages.where('status = ?', 0).count,
                    mas_reciente: us.messages.sort_by(&:timestamp).first.try(:timestamp),
                    total: us.messages.count
        }
      }
      ar.push temp_hash
    end
  end

  def self.users_with_messages
    usuarios = includes(:messages).order('messages.timestamp DESC')
    usuarios.inject([]) do |ar, us|
      temp_hash = {
        email: us.email,
        usuario_id: us.id,
        mensaje: {  no_leidos: us.messages.where('status = ?', 0).count,
                    mas_reciente: us.messages.sort_by(&:timestamp).first.try(:timestamp),
                    total: us.messages.count
        }
      }
      ar.push temp_hash
    end
  end

  def user_hash
    datos_usuario = userdata
    {
      email:    email,
      name:     datos_usuario.nombre,
      lastname: datos_usuario.apellido,
      type:     datos_usuario.tipo,
      city:     datos_usuario.city,
      state:    datos_usuario.state
    }
  end

  delegate :type, to: :membership, prefix: true

  private

  def initialize_user_data2
    create_userdata nombre: 'unset',
                    apellido: 'unset',
                    tipo: 0,
                    city: 'unset',
                    state: 'unset'
  end

  def initialize_user_data
    # from: http://stackoverflow.com/questions/3808782/rails-best-practice-how-to-create-dependent-has-one-relations
    build_userdata
    true
  end

  def initialize_wallet
    build_wallet
    true
  end

  def initialize_membership
    build_membership
    true
  end

  def skip_confirmation!
    self.confirmed_at = Time.now
  end

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :remember_me, :confirmed_at)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.confirm!
    end
  end

  def self.from_android_fb_auth(auth)
    # Security check
    app_auth = FbGraph2::Auth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'])
    app_auth.debug_token!(auth[:access_token])

    provider = 'facebook'
    user = FbGraph2::User.new(auth[:user_id]).authenticate(auth[:access_token]).fetch(fields: [:name, :email, :first_name, :last_name])
    # Fetch check
    if user.name.to_s == ''
      errors.add_to_base 'cannot fetch facebook data'
      return false
    end

    # If API doesnt return an email, create a fake one
    user.email = "#{user.id}_fb_user@facebook.com" if user.email.to_s == ''
    puts user.email

    where(provider: provider, uid: user.id).first_or_create do |u|
      u.email = user.email
      u.password = Devise.friendly_token[0, 20]
      u.name = user.name
      u.confirm!
    end
  end
end
