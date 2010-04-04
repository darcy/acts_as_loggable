class ActsAsLoggableMigrationGenerator < Rails::Generator::Base 
  def manifest 
    record do |m| 
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "acts_as_loggable_migration"
    end
  end
end
