class User < ActiveRecord::Base
  validates_presence_of :cobot_id
  has_many :spaces

  def self.find_or_create_for_cobot_id(cobot_id)
    user = User.find_by_cobot_id(cobot_id)
    user || User.create!(cobot_id: cobot_id)
  end
  
  def qb_connected?
    qb_token?
  end
end
