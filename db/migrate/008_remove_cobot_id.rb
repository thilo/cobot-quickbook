class RemoveCobotId < ActiveRecord::Migration
  def self.up
    remove_column :customers, :cobot_id
  end

  def self.down
    add_column :customers, :cobot_id, :string
  end
end