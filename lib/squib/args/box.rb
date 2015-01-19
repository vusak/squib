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

      def load(args, cmd_defaults = {}, dpi = 300, cards = 1)
        extract(args, cmd_defaults)
          .convert_units(parameters, dpi)
          .expand(by: cards)
      end

    end

  end
end