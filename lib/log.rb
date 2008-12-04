class Log < ActiveRecord::Base
  belongs_to :loggable, :polymorphic => true
  # validates_presence_of :loggable_type, :loggable_id
  has_many :log_details, :dependent => :destroy
  
  # NOTE: logs belong to a user
  belongs_to :user
  belongs_to :owner, :polymorphic => true
  
  def add_detail label, detail
    return false unless label
    log_details << LogDetail.new(:label => label, :detail => detail.to_s)
  end
  
  #
  # submit as details= [
  #  [ "Success", false ],
  #  [ "Transaction ID", 2  ],
  #  [ "Message", "Lorem ipsum dolor sit amet, consectetur adipisicing elit laborum."]
  # ]
  #
  def details= details
    return false unless details.is_a? Array
    details.each do |detail|
      return false unless (detail.is_a? Array and detail.length == 2)
      return false unless add_detail detail[0], detail[1]
    end
  end
  
  def details
    log_details
  end
  
  # Helper class method to lookup all logs assigned
  # to all loggable types for a given user.
  def self.find_logs_by_user(user)
    find(:all,
      :conditions => ["user_id = ?", user.id],
      :order => "created_at DESC"
    )
  end
  
  # Helper class method to look up all logs for 
  # loggable class name and loggable id.
  def self.find_logs_for_loggable(loggable_str, loggable_id)
    find(:all,
      :conditions => ["loggable_type = ? and loggable_id = ?", loggable_str, loggable_id],
      :order => "created_at DESC"
    )
  end

  # Helper class method to look up a loggable object
  # given the loggable class name and id 
  def self.find_loggable(loggable_str, loggable_id)
    loggable_str.constantize.find(loggable_id)
  end
end