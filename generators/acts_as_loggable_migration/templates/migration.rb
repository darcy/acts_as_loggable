class ActsAsLoggableMigration < ActiveRecord::Migration
  def self.up
    create_table "logs" do |t|
      t.string "message"
      t.integer "loggable_id"
      t.string "loggable_type"
      t.integer "user_id"
      t.string "group"
      t.integer "owner_id"
      t.string "owner_type"
      t.timestamps
    end
    add_index "logs", ["loggable_id","loggable_type"]
    
    create_table "log_details" do |t|
      t.integer "log_id"
      t.string "label"
      t.text "detail"
    end
  end

  def self.down
    drop_table :logs
    drop_table :log_details
  end
end
