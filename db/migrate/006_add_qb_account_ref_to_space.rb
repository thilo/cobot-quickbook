class AddQbAccountRefToSpace < ActiveRecord::Migration
  def self.up
    add_column :spaces, :qb_account_ref, :integer
  end

  def self.down
    remove_column :spaces, :qb_account_ref
  end
end