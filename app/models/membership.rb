# == Schema Information
#
# Table name: memberships
#
#  id              :integer          not null, primary key
#  m_type          :integer
#  total_bought    :integer
#  payments_count  :integer
#  expire_date     :datetime
#  last_payment_at :datetime
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Membership < ActiveRecord::Base
  belongs_to :user
  before_create :set_defaults

  PREMIUM_MEM_LEVEL = 1
  PREMIUM_MEM_PRICE = 20.00
  PREMIUM_MEM_CREDITS = 20
  MIPYME_MEM_LEVEL = 2
  MIPYME_MEM_PRICE = 40.00
  MIPYME_MEM_CREDITS = 40
  MEM_DURATION = (60 * 60 * 24 * 30) # in seconds

  def upgrade(level, payment_params)
    # if payment is aproved:
    # upgrade m_type to level
    # increase by total transaction total_bought
    # increase by one payments_count
    # if expire_date is older than now update by now plus 30 days
    # if expire_date is newer than noew update expire_date plus 30 days
    # set to now last_payment_at
    # increase credits by X amount

    # PREMIUM level
    fail 'wrong memberhip level' if (level > 2) || (level < 1)
    if level == PREMIUM_MEM_LEVEL
      payment = Payment2.new(PREMIUM_MEM_PRICE, mem_payment_descritpion(level), payment_params)
      return upgrade_to_premium if payment.do_payment
    end
    # MIPYME level
    if level == MIPYME_MEM_LEVEL
      payment = Payment2.new(MIPYME_MEM_PRICE, mem_payment_descritpion(level), payment_params)
      return upgrade_to_mipyme if payment.do_payment
    end
    false
  end

  def upgrade_to_premium
    self.m_type = PREMIUM_MEM_LEVEL
    self.total_bought += PREMIUM_MEM_PRICE
    self.payments_count += 1
    update_dates
    self.last_payment_at ||= Time.now
    user.wallet.add_credits(PREMIUM_MEM_CREDITS)
    save
  end

  def upgrade_to_mipyme
    self.m_type = MIPYME_MEM_LEVEL
    self.total_bought += MIPYME_MEM_PRICE
    self.payments_count += 1
    update_dates
    self.last_payment_at ||= Time.now
    user.wallet.add_credits(MIPYME_MEM_CREDITS)
    save
  end

  def data_h
    { m_type: m_type, expire_date: expire_date }
  end

  private

  def set_defaults
    self.m_type ||= 0
    self.total_bought ||= 0
    self.payments_count ||= 0
  end

  def update_dates
    # How to avoid giving mipyme days free?
    if expire_date.nil?
      self.expire_date ||= Time.now + MEM_DURATION
    elsif (self.expire_date <= Time.now)
      self.expire_date = Time.now + MEM_DURATION
    elsif self.expire_date > Time.now
      self.expire_date = self.expire_date + MEM_DURATION
    end
  end

  def mem_payment_descritpion(level)
    membreship = ['', 'PREMIUM', 'MIPYME'][level]
    "Adquisición de membresia #{membreship}"
  end
end
