class AddCobotIdToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :cobot_id, :string, allow_null: false
  end

  def self.down
    remove_column :customers, :cobot_id
  end
end