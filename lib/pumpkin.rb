Dir[File.join(File.dirname(__FILE__),'extensions/**/*.rb')].each {|f| require f}

module Pumpkin
  autoload :Content, 'pumpkin/content'
  
  module LoggerHelper
    def logger
      Pumpkin.logger
    end
  end
  
  class << self
    attr_accessor :logger
    
    def version
      @version ||= File.read(File.dirname(__FILE__) + '/../VERSION').strip
    end    
  end
end

require 'pumpkin/application'
require 'pumpkin/runner'