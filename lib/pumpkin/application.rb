RACK_ENV = ENV["RACK_ENV"] ||= "development" unless defined? RACK_ENV

def root_path(*args)
  File.join(File.dirname(__FILE__), *args)
end

require 'logger'
class ::Logger; alias_method :write, :<<; end

require "bundler"
Bundler.setup(:default, RACK_ENV.to_sym)
Bundler.require

class Pumpkin::Application < Sinatra::Base
  set :app_file, __FILE__
  set :environment, RACK_ENV
  set :raise_errors, true if development?
  set :logging, false
  set :sessions, false
  set :root, root_path
  set :run, Proc.new { $0 == __FILE__ }
  set :static, true
  set :views, root_path("application", "views")
  
  use Rack::CommonLogger, Pumpkin.logger
  helpers Pumpkin::LoggerHelper
end

MongoMapper.database = "pumpkin_#{RACK_ENV}"

# Load all application files.
Dir[root_path("application/**/*.rb")].each {|f| require f}

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end