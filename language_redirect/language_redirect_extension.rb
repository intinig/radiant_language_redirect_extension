class LanguageRedirectExtension < Radiant::Extension
  version "0.1"
  description "Port of the original Language Redirect Behavior"
  url "http://language_redirect.com"

  def activate
    LanguageRedirectPage
  end
  
  def deactivate
  end
    
end