class Customer < ActiveRecord::Base
  include QbObject
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :space_id
end