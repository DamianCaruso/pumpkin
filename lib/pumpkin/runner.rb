require 'thor'

module Pumpkin
  class Runner < Thor
    include Thor::Actions

    desc "start", "Start Pumpkin Server"
    method_option :server,      :type => :string,  :aliases => "-s", :desc => "Specify rack server/handler (default is Thin)"
    method_option :bind,        :type => :string,  :aliases => "-h", :required => true, :default => "localhost", :desc => "Bind to HOST address"
    method_option :port,        :type => :numeric, :aliases => "-p", :required => true, :default => 3000, :desc => "Use PORT"
    method_option :environment, :type => :string,  :aliases => "-E", :required => true, :default => "development", :desc => "Framework environment (default: development)"
    method_option :debug,       :type => :boolean, :aliases => "-D", :default => false, :desc => "DEBUG mode"
    def start
      require "pumpkin/application"
      prepare_logger
      Pumpkin::Application.run!(options.symbolize_keys)
    end
    
    desc "console", "Boots up Pumpkin irb console"
    def console
      require "pumpkin"
      ARGV.clear
      puts "=> Loading Pumpkin #{options.environment} console"
      require "irb"
      require "irb/completion"
      IRB.start
    end

    desc "version", "Show Pumpkin Version"
    map "-v" => :version, "--version" => :version
    def version
      puts "Pumpkin #{File.read(File.dirname(__FILE__) + '/../../VERSION').strip}"
    end

    protected
      def store_pid(pid)
        FileUtils.mkdir_p(File.dirname(options.pid_file))
        File.open(options.pid_file, 'w'){|f| f.write("#{pid}\n")}
      rescue => e
        puts e
        exit
      end
      
      def prepare_logger
        logger = ::Logger.new(STDOUT)
        logger.level = options.debug? ? Logger::DEBUG : Logger::INFO
        logger.formatter = proc { |severity, datetime, progname, msg|
          "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}  #{msg}\n"
        }
        Pumpkin.logger = logger
      end
      
      def self.banner(task=nil, *args)
        "pumpkin #{task.name}"
      end

      def capture(stream)
        begin
          stream = stream.to_s
          eval "$#{stream} = StringIO.new"
          yield
          result = eval("$#{stream}").string
        ensure
          eval("$#{stream} = #{stream.upcase}")
        end
        result
      end
      alias :silence :capture
  end
end