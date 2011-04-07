require File.expand_path(File.join("..", "..", "..", "..", "..", "..", "config", "environment"), __FILE__) # load rails environment & initalizers
require File.expand_path(File.join("..", "..", "..", "app", "models", "plugin_event.rb"), __FILE__)

namespace I18n.t("name").downcase.to_sym do
 namespace PluginEvent.model_name.human(:count => :other).downcase.to_sym do   
    desc "#{I18n.t("single.install")} #{PluginEvent.model_name.human(:count => :other)}"
    task :install => :environment do
      PluginEvent.install
      puts I18n.t("notice.item_install_success", :item => PluginEvent.model_name.human(:count => :other))
    end
  end 

 namespace PluginEvent.model_name.human(:count => :other).downcase.to_sym do   
    desc "#{I18n.t("single.uninstall")} #{PluginEvent.model_name.human(:count => :other)}"
    task :uninstall => :environment do
      PluginEvent.uninstall
      puts I18n.t("notice.item_uninstall_success", :item => PluginEvent.model_name.human(:count => :other))      
    end
  end   
end
