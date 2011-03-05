module Tilt
  # Json template implementation. See:
  # https://github.com/dewski/json_builder
  class JsonTemplate < Template
    def initialize_engine
      return if defined?(::JSONBuilder)
      require_template_library 'json_builder'
    end

    def prepare; end
    
    def evaluate(scope, locals, &block)
      if data.respond_to?(:to_str)
        super(scope, locals, &block)
      else
        ::JSONBuilder::Generator.new.tap(&data).compile!
      end
    end

    def precompiled_preamble(locals)
      return super if locals.include? :json
      "json = ::JSONBuilder::Generator.new\n#{super}"
    end

    def precompiled_postamble(locals)
      "json.compile!"
    end

    def precompiled_template(locals)
      data.to_str
    end
  end
  register 'json', JsonTemplate
end