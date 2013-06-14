class Invoice < ActiveRecord::Base
  include QbObject
  validates_presence_of :cobot_id
  validates_uniqueness_of :cobot_id
end