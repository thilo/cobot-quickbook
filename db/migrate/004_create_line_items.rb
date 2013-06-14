class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items, :force => true do |t|
      t.belongs_to :space
      t.integer :qb_id
      t.text :description
    end
  end

  def self.down
    drop_table :line_items
  end
end
