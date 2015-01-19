require 'ostruct'
require 'squib/constants'

module Squib
  module Args

    module ArgExtractor

      def extract(args={}, cmd_defaults)
        lookup = SYSTEM_DEFAULTS.merge(cmd_defaults).merge(args)
        self.class.parameters.each do |p|
          instance_variable_set "@#{p}", lookup[p]
        end
        self.class.class_eval { attr_reader *(parameters) }
        self
      end

      def expand(by: 1)
        self.class.parameters.each do |p|
          p_str = "@#{p}"
          p_val = instance_variable_get(p_str)
          unless p_val.respond_to? :each
            instance_variable_set p_str, [p_val] * by
          end
        end
        self
      end

      # Convert units
      # :nodoc:
      # @api private
      def convert_units(dpi: CONFIG_DEFAULTS['dpi'])
        self.class.params_with_units.each do |p|
          p_str = "@#{p}"
          p_val = instance_variable_get(p_str)
          if p_val.respond_to? :each
            arr = p_val.map { |x| convert_one(x, dpi) }
            instance_variable_set p_str, arr
          else
            instance_variable_set p_str, convert_one(p_val, dpi)
          end
        end
        self
      end

      def convert_one(arg, dpi)
        case arg.to_s.rstrip
        when /in$/ #ends with "in"
          arg.rstrip[0..-2].to_f * dpi
        when /cm$/ #ends with "cm"
          arg.rstrip[0..-2].to_f * dpi * INCHES_IN_CM
        else
          arg
        end
      end

      def [](i)
        card_arg = OpenStruct.new
        self.class.parameters.each do |p|
          p_val = instance_variable_get("@#{p}")
          card_arg[p] = p_val[i]
        end
        card_arg
      end

    end

  end
end