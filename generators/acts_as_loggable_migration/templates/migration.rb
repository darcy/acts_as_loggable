class ActsAsLoggableMigration < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string :message
      t.references :loggable, :polymorphic => true
      t.references :user
      t.string :group
      t.references :owner,  :polymorphic => true
      t.timestamps
    end
    
    add_index :logs, [:loggable_id, :loggable_type]
    
    create_table :log_details do |t|
      t.references :log
      t.string :label
      t.text :detail
    end
  end

  def self.down
    drop_table :logs
    drop_table :log_details
  end
end
