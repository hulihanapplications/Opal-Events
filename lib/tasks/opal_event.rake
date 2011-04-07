require File.expand_path(File.join("..", "..", "..", "..", "..", "..", "config", "environment"), __FILE__) # load rails environment & initalizers
require File.expand_path(File.join("..", "..", "..", "app", "models", "plugin_event.rb"), __FILE__)

namespace I18n.t("name").downcase.to_sym do
 namespace PluginEvent.model_name.human(:count => :other).downcase.to_sym do   
    desc "#{I18n.t("single.install")} #{PluginEvent.model_name.human(:count => :other)}"
    task :install => :environment do
      PluginEvent.install
      puts 
    end
  end 
end
