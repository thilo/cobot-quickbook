class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :token
      t.string :qb_token
      t.string :qb_secret
      t.string :qb_realm_id
      t.string :cobot_id
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
