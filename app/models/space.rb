class Space < ActiveRecord::Base
  validates_presence_of :cobot_id, :qb_account_ref
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :customers, dependent: :destroy
  validates_uniqueness_of :cobot_id
end
