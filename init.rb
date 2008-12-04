require 'acts_as_loggable'
ActiveRecord::Base.send(:include, Acts::Loggable)
