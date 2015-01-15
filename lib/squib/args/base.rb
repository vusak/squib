module Squib
  module Args
    module Extractor

      def extract(args={}, cmd_defaults={})
        self.class.parameters.each do |p|
          instance_variable_set("@#{p}", args[p])
        end
        self
      end

      def expand_singletons?
        false
      end

    end
  end
end