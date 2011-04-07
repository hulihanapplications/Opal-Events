class PluginEvent < ActiveRecord::Base
  belongs_to :plugin
  belongs_to :item
  belongs_to :user
  
  def self.install # install this plugin
    # Create Database Structure & Records 
    plugin = Plugin.create(:name => "Event", :is_enabled => "1", :is_builtin => "0") # The plugin attribute: name is used for index only and is never displayed to user, it also has nothing to do with I18n. It is used to find the corresponding Model, ie: PluginEvent.
    if !ActiveRecord::Base.connection.tables.include?("plugin_events") 
      ActiveRecord::Migration.create_table :plugin_events do |t|
       t.column :item_id, :integer, :nil => false
       t.column :user_id, :integer, :nil => false
       t.column :title, :string, :default => ""
       t.column :description, :text, :default => ""
       t.column :date, :datetime # date of event
       t.column :price, :string
       t.column :created_at, :datetime #this will get populated automatically
       t.column :updated_at, :datetime #this will get populated automatically
       t.column :is_approved, :string, :default => "0", :limit => 1     
      end
    end 
    
    # Create Plugin Settings
    PluginSetting.create(:plugin_id => plugin.id, :name => "display_upcoming_events", :value => "1", :setting_type => "System", :item_type => "bool")    
    
    return true
  rescue Exception => e 
    logger.error I18n.t("notice.item_install_failure", :item => Plugin.model_name.human) + " #{e}" 
    return false
  end 
  
  def self.uninstall # uninstall this plugin
    plugin = Plugin.find_by_name("Event") # Delete Plugin Record
    plugin.destroy if plugin
    ActiveRecord::Migration.drop_table :plugin_events if ActiveRecord::Base.connection.tables.include?("plugin_events") # drop table if it exists
    return true
  end
  
  
  def is_approved?
     if self.is_approved == "1"
       return true
     else # not approved
       return false
     end
  end  
end