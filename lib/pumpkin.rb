require 'bundler'
Bundler.setup(:default, RACK_ENV.to_sym) if defined?(Bundler)
require 'mongo_mapper'
require 'carrierwave'

Dir[File.join(File.dirname(__FILE__),'extensions/**/*.rb')].each {|f| require f}

module Pumpkin
  autoload :Content, 'pumpkin/content'
end