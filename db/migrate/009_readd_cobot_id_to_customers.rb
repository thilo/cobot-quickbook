class AddCobotMembershipIdToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :cobot_membership_id, :string
  end

  def self.down
    remove_column :customers, :cobot_membership_id
  end
end