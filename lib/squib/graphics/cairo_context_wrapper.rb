require 'forwardable'
require 'squib/graphics/gradient_regex'

module Squib
  module Graphics
    class CairoContextWrapper
      extend Forwardable
      attr_accessor :cairo_cxt, :pango_layout

      def initialize(cairo_cxt)
        @cairo_cxt = cairo_cxt
        @pango_layout = nil
      end

      def_delegators :cairo_cxt, :save, :set_source_color, :paint, :restore,
        :translate, :rotate, :move_to, :width, :height,
        :rounded_rectangle, :set_line_width, :stroke, :fill,
        :set_source, :scale, :render_rsvg_handle, :circle, :triangle, :line_to,
        :operator=, :show_page, :clip, :transform, :mask

      def set_source_squibcolor(arg)
        if match = arg.match(LINEAR_GRADIENT)
          x1, y1, x2, y2 = match.captures
          linear = Cairo::LinearPattern.new(x1.to_f, y1.to_f, x2.to_f, y2.to_f)
          arg.scan(STOPS).each do |color, offset|
            linear.add_color_stop(offset.to_f, color)
          end
          @cairo_cxt.set_source(linear)
        elsif match = arg.match(RADIAL_GRADIENT)
          x1, y1, r1, x2, y2, r2  = match.captures
          linear = Cairo::RadialPattern.new(x1.to_f, y1.to_f, r1.to_f,
                                            x2.to_f, y2.to_f, r2.to_f)
          arg.scan(STOPS).each do |color, offset|
            linear.add_color_stop(offset.to_f, color)
          end
          @cairo_cxt.set_source(linear)
        else
          @cairo_cxt.set_source_color(arg)
        end
      end

      def create_pango_layout
        @pango_layout = @cairo_cxt.create_pango_layout
        return @pango_layout
      end

      def update_pango_layout
        @cairo_cxt.update_pango_layout(@pango_layout)
      end

      def show_pango_layout
        @cairo_cxt.show_pango_layout(@pango_layout)
      end

      def svg(embed:, file:)
        if @pango_layout != nil
          puts "CairoContextWrapper::svg there is a pango_layout"
          if @pango_layout.text.length > 0
            puts "CairoContextWrapper::svg there is text"
            if @pango_layout.text.include? embed
              puts "CairoContextWrapper::svg there is an embed match"
              svg = RSVG::Handle.new_from_file(file)
              if svg != nil
                puts "CairoContextWrapper::svg file exists"

                iter = @pango_layout.iter

                glyph = iter.run

                puts "glyph.item.length = #{glyph.item.length}"

                puts "glyph.item.to_s = #{glyph.item.to_s}"
              end
            end
          end
        end
      end
    end
  end
end
