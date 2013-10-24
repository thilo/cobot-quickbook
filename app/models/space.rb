class Space < ActiveRecord::Base
  validates_presence_of :cobot_id, :qb_account_ref
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :customers, dependent: :destroy

  scope :enabled, ->{where(disabled: false)}
  scope :disabled, ->{where(disabled: true)}

  validates_uniqueness_of :cobot_id

  def disable
    update_attribute(:disabled, true)
  end

  def enable
    update_attribute(:disabled, false)
  end
end
