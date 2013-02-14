class LanguageRedirectExtension < Radiant::Extension
  version "#{File.read(File.expand_path(File.dirname(__FILE__)) + '/VERSION')}"
  description "Enables redirects to the appropriate language section based on the content encoding preferred by the Web browser."
  url "https://github.com/avonderluft/radiant_language_redirect_extension"

  def activate
    Page.send :include, LanguageRedirectTags
    LanguageRedirectPage
  end

end