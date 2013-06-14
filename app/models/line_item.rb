class LineItem < ActiveRecord::Base
  validates_presence_of :description
  include QbObject
end