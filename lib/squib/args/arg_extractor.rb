require 'squib/constants'

module Squib
  module Args

    module ArgExtractor

      def extract(args={}, cmd_defaults={})
        lookup = SYSTEM_DEFAULTS.merge(cmd_defaults).merge(args)
        self.class.parameters.each do |p|
          instance_variable_set "@#{p}", lookup[p]
        end
        self.class.class_eval { attr_reader *(parameters) }
        self
      end

      def expand(by: 1)
        if expand_singletons?
          self.class.parameters.each do |p|
            p_str = "@#{p}"
            p_val = instance_variable_get(p_str)
            unless p_val.respond_to? :each
              instance_variable_set p_str, [p_val] * by
            end
          end
        end
        self
      end

      # Convert units
      # :nodoc:
      # @api private
      def convert_units(dpi, arg)
        # self.class.parameters.each do |p|
        #     p_str = "@#{p}"
        #   case arg.to_s.rstrip
        #   when /in$/ #ends with "in"
        #     arg.rstrip[0..-2].to_f * dpi
        #   when /cm$/ #ends with "cm"
        #     arg.rstrip[0..-2].to_f * dpi * Squib::INCHES_IN_CM
        #   else
        #     arg
        #   end
        # end
        self
      end

    end

  end
end