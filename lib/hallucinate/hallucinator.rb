module Hallucinate
  module Hallucinator
    def self.included(base)
      base.class_eval do
        def method_missing(method_name, *args, &block)
          AIResponseGenerator.new.generate_response(self.class.name, method_name, *args)
        end

        def respond_to_missing?(method_name, include_private = false)
          true
        end
      end
    end
  end
end
