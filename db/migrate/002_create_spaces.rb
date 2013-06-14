class CreateSpaces < ActiveRecord::Migration
  def self.up
    create_table :spaces, :force => true do |t|
      t.belongs_to :user
      t.string :cobot_id
      t.integer :qb_id
      t.text :address
      t.string :name
      t.string :company
      t.string :post_code
      t.string :country
      t.string :state
      t.timestamps
    end
  end

  def self.down
    drop_table :spaces
  end
end