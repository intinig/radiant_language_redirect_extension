namespace :radiant do
  namespace :extensions do
    namespace :language_redirect do
      
      desc "Runs the migration of the Language Redirect extension"
      task :migrate do
        require 'extension_migrator'
        if ENV["VERSION"]
          LanguageRedirectExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          LanguageRedirectExtension.migrator.migrate
        end
      end
    
    end
  end
end