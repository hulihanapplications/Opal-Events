class PluginEventsController < ApplicationController
 before_filter :find_item # look up item 
 before_filter :find_plugin # look up item  
 before_filter :get_my_group_plugin_permissions # get permissions for this plugin  
 before_filter :check_item_edit_permissions, :only => [:change_approval] # list of actions that don't require that the item is editable by the user
 before_filter :can_group_read_plugin, :only => [:view, :rss]
 before_filter :can_group_create_plugin, :only => [:create]
 before_filter :can_group_delete_plugin, :only => [:delete] 
  
  def create
     @event = PluginEvent.new(params[:plugin_event])
     @event.user_id = @logged_in_user.id
     @event.item_id = @item.id          
     @event.is_approved = "1" if !@my_group_plugin_permissions.requires_approval? || @item.is_user_owner?(@logged_in_user) || @logged_in_user.is_admin? # approve if not required or owner or admin 
     
     if @event.save
      Log.create(:user_id => @logged_in_user.id, :item_id => @item.id,  :log_type => "new", :log => t("log.item_create", :item => @plugin.model_name.human, :name => @event.title))        
      flash[:success] = t("notice.item_create_success", :item => @plugin.model_name.human)
      flash[:success] += " " + t("notice.item_needs_approval", :item => @plugin.model_name.human) if !@event.is_approved?

     else # fail saved 
      flash[:failure] = t("notice.item_create_failure", :item => @plugin.model_name.human)
     end 
    redirect_to :action => "view", :controller => "items", :id => @item.id, :anchor => @plugin.model_name.human(:count => :other)  
 end 
 
 def delete
   @event = PluginEvent.find(params[:event_id])
   if @event.destroy
     Log.create(:user_id => @logged_in_user.id, :item_id => @item.id,  :log_type => "delete", :log => t("log.item_delete", :item => @plugin.model_name.human, :name => @event.title))      
     flash[:success] = t("notice.item_delete_success", :item => @plugin.model_name.human)     
   else # fail saved 
     flash[:failure] = t("notice.item_delete_failure", :item => @plugin.model_name.human)        
   end
   redirect_to :action => "view", :controller => "items", :id => @item.id, :anchor => @plugin.model_name.human(:count => :other)  
 end
 
 def rss
     @event = PluginEvent.find(params[:event_id])
     @site_url = request.env["HTTP_HOST"]
     @posts = PluginEventPost.find(:all, :conditions => ["plugin_event_id = ?", @event.id], :limit => 30) 
     render :layout => false  
 end   

 def change_approval
    @event = PluginEvent.find(params[:event_id])    
    if @event.is_approved?
      approval = "0" # set to unapproved if approved already    
      log_msg = t("log.item_unapprove", :item => @plugin.model_name.human, :name => "#{@event.title}")
    else
      approval = "1" # set to approved if unapproved already    
      log_msg = t("log.item_approve", :item => @plugin.model_name.human, :name => "#{@event.title}")
    end
    
    if @event.update_attribute(:is_approved, approval)
      Log.create(:user_id => @logged_in_user.id, :item_id => @item.id,  :log_type => "update", :log => log_msg)      
      flash[:success] = t("notice.item_#{"un" if approval == "0"}approve_success", :item => @plugin.model_name.human)  
    else
      flash[:failure] = t("notice.item_save_failure", :item => @plugin.model_name.human)
    end
   redirect_to :action => "view", :controller => "items", :id => @item.id, :anchor => @plugin.model_name.human(:count => :other) 
 end
 
end  
