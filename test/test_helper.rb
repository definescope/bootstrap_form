require 'timecop'
require 'diffy'
require 'mocha/mini_test'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

def setup_test_fixture
  @user = User.new(email: 'steve@example.com', password: 'secret', comments: 'my comment')
  @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
  @horizontal_builder = BootstrapForm::FormBuilder.new(:user, @user, self, { layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10" })
  I18n.backend.store_translations(:en, {activerecord: {help: {user: {password: "A good password should be at least six characters long"}}}})
end

class ActionView::TestCase
  def assert_equivalent_xml(expected, actual)
    expected_xml = Nokogiri::XML(expected)
    actual_xml = Nokogiri::XML(actual)
    equivalent = EquivalentXml.equivalent?(expected_xml, actual_xml)
    assert equivalent, lambda {
      # using a lambda because diffing is expensive
      Diffy::Diff.new(expected_xml.root, actual_xml.root).to_s(:color)
    }
  end
end
