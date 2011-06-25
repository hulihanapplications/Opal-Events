class CreatePluginEvents < ActiveRecord::Migration
  def self.up
    create_table :plugin_events do |t|
       t.column :item_id, :integer, :nil => false
       t.column :user_id, :integer, :nil => false
       t.column :title, :string
       t.column :description, :text
       t.column :date, :datetime # date of event
       t.column :price, :string
       t.column :created_at, :datetime
       t.column :updated_at, :datetime
       t.column :is_approved, :string, :default => "0", :limit => 1 
    end
  end
 
  def self.down
    drop_table :plugin_events
  end
end