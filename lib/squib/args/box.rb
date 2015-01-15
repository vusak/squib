require 'squib/args/base'

module Squib
  module Args
    class Box
      include Extractor

      def self.parameters
        [:x, :y, :width, :height]
      end

      attr_reader *(self.parameters)

      def expand_singletons?
        true
      end

      def defaults
      end
    end
  end
end