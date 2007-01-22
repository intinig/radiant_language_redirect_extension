require File.dirname(__FILE__) + '/../test_helper'

class LanguageRedirectExtensionTest < Test::Unit::TestCase
  
  # Replace this with your real tests.
  def test_this_extension
    flunk
  end
  
  def test_initialization
    assert_equal RADIANT_ROOT + '/vendor/extensions/language_redirect', LanguageRedirectExtension.root
    assert_equal 'Language Redirect', LanguageRedirectExtension.extension_name
  end
  
end
