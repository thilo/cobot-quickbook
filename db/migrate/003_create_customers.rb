class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers, :force => true do |t|
      t.belongs_to :space
      t.integer :qb_id
      t.text  :address
      t.string  :name
      t.string :company
      t.string :post_code
      t.string :country
      t.string :state
      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end