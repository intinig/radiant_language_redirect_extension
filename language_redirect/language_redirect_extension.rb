class LanguageRedirectExtension < Radiant::Extension
  version "0.2"
  description "Port of the original Language Redirect Behavior"
  url "http://medlar.it"

  def activate
    LanguageRedirectPage
  end
  
  def deactivate
  end
    
end