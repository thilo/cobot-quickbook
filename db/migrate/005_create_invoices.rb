class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices, :force => true do |t|
      t.belongs_to :space
      t.string :cobot_id
      t.integer :qb_id
    end
  end

  def self.down
    drop_table :invoices
  end
end