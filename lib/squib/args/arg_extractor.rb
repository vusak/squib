module Squib
  module Args
    module ArgExtractor

      def extract(args={}, cmd_defaults={})
        self.class.parameters.each do |p|
          instance_variable_set "@#{p}", args[p] || cmd_defaults[p]
        end
        self.class.class_eval { attr_reader *(parameters) }
        self
      end

      def and_expand(by: 1)
        if expand_singletons?
          self.class.parameters.each do |p|
            p_str = "@#{p}"
            p_val = instance_variable_get(p_str)
            unless p_val.respond_to? :each
            # !opts[api_p_str].respond_to?(:each)
              instance_variable_set p_str, [p_val] * by
            end
          end
        end
      end

      def with_decksize(decksize)
        @decksize = decksize
        self
      def expand_singletons?
        false
      end

    end
  end
end