# ActsAsLoggable
module Acts #:nodoc:
  module Loggable #:nodoc:

    def self.included(base)
      base.extend ClassMethods  
    end

    module ClassMethods
      def acts_as_loggable
        has_many :logs, :as => :loggable, :dependent => :destroy, :order => 'created_at DESC'
        include Acts::Loggable::InstanceMethods
        extend Acts::Loggable::SingletonMethods
      end
    end
    
    # This module contains class methods
    module SingletonMethods
      # Helper method to lookup for loggable_types for a given object.
      # This method is equivalent to obj.logs.
      def find_logs_for(obj)
        loggable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
       
        Log.find(:all,
          :conditions => ["loggable_id = ? and loggable_type = ?", obj.id, loggable],
          :order => "created_at DESC"
        )
      end
      
      #finds all logs related to this obj. checks loggable, and owner, and user (if obj is a user class)
      # Helper class method to lookup logs for
      # the mixin loggable type written by a given user.  
      # This method is NOT equivalent to Log.find_logs_for_user
      def find_logs_by_user(user) 
        loggable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
        
        Log.find(:all,
          :conditions => ["user_id = ? and loggable_type = ?", user.id, loggable],
          :order => "created_at DESC"
        )
      end
    end
    
    # This module contains instance methods
    module InstanceMethods
      # Helper method to sort logs by date
      def logs_ordered_by_submitted
        Log.find(:all,
          :conditions => ["loggable_id = ? and loggable_type = ?", id, self.type.name],
          :order => "created_at DESC"
        )
      end
      
      # Helper method that defaults the submitted time.
      def add_log(log)
        logs << log
      end

      def related_logs(limit=nil, order="created_at DESC")
        type = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self.class).to_s
        conditions = "(loggable_id=#{self.id} and loggable_type='#{type}') or (owner_id=#{self.id} and owner_type='#{type}')"
        conditions << " or user_id=#{self.id}" if type == "User"
        Log.find(:all, :conditions => conditions, :order => order, :limit => limit)
      end
      

    end
    
  end
end
