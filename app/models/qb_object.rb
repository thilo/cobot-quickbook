module QbObject
  def self.included(klass)
    klass.instance_eval do
      validates_presence_of :qb_id
      validates_presence_of :space_id
      belongs_to :space
    end
  end
end