require 'acts_as_loggable'
ActiveRecord::Base.send(:include, Emporium::Acts::Loggable)
