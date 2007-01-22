require File.dirname(__FILE__) + "/../../../../test/test_helper" unless defined? TEST_ROOT

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures = false
end