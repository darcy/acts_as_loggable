class LogDetail < ActiveRecord::Base
  belongs_to :log
  validates_presence_of :label #if you are creating a detail, you at least need to specify the label
end