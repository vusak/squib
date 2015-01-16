require 'squib/args/arg_extractor'

module Squib
  module Args
    class Box
      include ArgExtractor

      def self.parameters
        %i(x y width height)
      end

      def expand_singletons?
        true
      end
    end
  end
end