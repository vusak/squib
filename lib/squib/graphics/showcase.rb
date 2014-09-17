module Squib
  class Deck
    # Actually render the showcase
    # :nodoc:
    # @api private
    def render_showcase(range, trim, trim_radius, file_to_save)
      out_width = range.size * @width
      out_height = @height * 2
      out_cc = Cairo::Context.new(Cairo::ImageSurface.new(out_height, out_width))
      cards = range.collect { |i| @cards[i] }

      cards.each_with_index do |card, i|
        out_cc.translate(100, 0)
        out_cc.set_source(card.surface)
        out_cc.paint
      end

      out_cc.target.write_to_png("#{dir}/#{prefix}#{i}.png")
    end

  end  
end