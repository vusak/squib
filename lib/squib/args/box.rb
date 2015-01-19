require 'squib/args/arg_extractor'

module Squib
  module Args

    class Box
      include ArgExtractor

      def self.parameters
        %i(x y width height)
      end

      def self.params_with_units
        %i(x y width height)
      end

    end

  end
end