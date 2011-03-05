ENV["RACK_ENV"] = "test"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'rack/test'

require 'pumpkin/application'

Pumpkin::Application.run! if Pumpkin::Application.run?

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

module Pumpkin
  module Test
    module Methods
      def app
        Pumpkin::Application.new
      end
    end
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Pumpkin::Test::Methods
  config.mock_with :rspec
end