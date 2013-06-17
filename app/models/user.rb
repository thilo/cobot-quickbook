class User < ActiveRecord::Base
  validates_presence_of :cobot_id, :token
  has_many :spaces

  def self.find_or_create_for_cobot_id(cobot_id, attributes = {})
    user = User.find_by_cobot_id(cobot_id)
    user || User.create!(attributes.merge({cobot_id: cobot_id}))
  end
  
  def qb_connected?
    qb_token?
  end
end
