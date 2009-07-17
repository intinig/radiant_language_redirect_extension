class LanguageRedirectExtension < Radiant::Extension
  version "0.2.1"
  description "Port of the original Language Redirect Behavior"
  url "http://medlar.it"

  def activate
    Page.send :include, LanguageRedirectTags
    LanguageRedirectPage
  end
  
  def deactivate
  end
    
end