require 'mongo_mapper'
require 'joint'

Dir[File.join(File.dirname(__FILE__),'extensions/**/*.rb')].each {|f| require f}

module Pumpkin
  autoload :Content, 'pumpkin/content'
end