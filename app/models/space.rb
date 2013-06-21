class Space < ActiveRecord::Base
  validates_presence_of :cobot_id, :qb_account_ref
  belongs_to :user
  has_many :line_items
  has_many :invoices
  has_many :customers
  validates_uniqueness_of :cobot_id
end
