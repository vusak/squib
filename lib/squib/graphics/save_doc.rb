module Squib
  class Deck

    # Lays out the cards in range and renders a PDF
    #
    # @example
    #   save_pdf file: 'deck.pdf', margin: 75, gap: 5, trim: 37
    #
    # @option opts file [String] the name of the PDF file to save. See {file:README.md#Specifying_Files Specifying Files}
    # @option opts dir [String] (_output) the directory to save to. Created if it doesn't exist.
    # @option opts width [Integer] (3300) the height of the page in pixels. Default is 11in * 300dpi. Supports unit conversion.
    # @option opts height [Integer] (2550) the height of the page in pixels. Default is 8.5in * 300dpi. Supports unit conversion.
    # @option opts margin [Integer] (75) the margin around the outside of the page. Supports unit conversion.
    # @option opts gap [Integer] (0) the space in pixels between the cards. Supports unit conversion.
    # @option opts trim [Integer] (0) the space around the edge of each card to trim (e.g. to cut off the bleed margin for print-and-play). Supports unit conversion.
    # @return [nil]
    # @api public
    def save_pdf(opts = {})
      opts = {width: 3300, height: 2550}.merge(opts)
      p = needs(opts, [:range, :paper_width, :paper_height, :file_to_save, :creatable_dir, :margin, :gap, :trim])
      cc = Cairo::Context.new(Cairo::PDFSurface.new("#{p[:dir]}/#{p[:file]}", p[:width], p[:height]))
      x = p[:margin]
      y = p[:margin]
      @progress_bar.start("Saving PDF to #{p[:dir]}/#{p[:file]}", p[:range].size) do |bar|
        p[:range].each do |i|
          surface = trim(@cards[i].cairo_surface, p[:trim], @width, @height)
          cc.set_source(surface, x, y)
          cc.paint
          bar.increment
          x += surface.width + p[:gap]
          if x > (p[:width] - surface.width - p[:margin])
            x = p[:margin]
            y += surface.height + p[:gap]
            if y > (p[:height] - surface.height - p[:margin])
              x = p[:margin]
              y = p[:margin]
              cc.show_page #next page
            end
          end
        end
      end
    end

    # Lays out the cards in range and renders a stitched PNG sheet
    #
    # @example
    #   save_png_sheet prefix: 'sheet_', margin: 75, gap: 5, trim: 37
    #
    # @option opts [Enumerable] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts colulmns [Integer] (1) the number of columns in the grid
    # @option opts rows [Integer] (:infinite) the number of rows in the grid. When set to :infinite, the sheet scales to the rows needed. If there are more cards than rows*columns, new sheets are started.
    # @option opts [String] prefix (card_) the prefix of the file name(s)
    # @option opts [String] count_format (%02d) the format string used for formatting the card count (e.g. padding zeros). Uses a Ruby format string (see the Ruby doc for Kernel::sprintf for specifics)
    # @option opts dir [String] (_output) the directory to save to. Created if it doesn't exist.
    # @option opts margin [Integer] (0) the margin around the outside of the page.
    # @option opts gap [Integer] (0) the space in pixels between the cards
    # @option opts trim [Integer] (0) the space around the edge of each card to trim (e.g. to cut off the bleed margin for print-and-play)
    # @return [nil]
    # @api public
    def save_sheet(opts = {})
      opts = {margin: 0}.merge(opts) # overriding the non-system default
      p = needs(opts, [:range, :prefix, :count_format, :creatable_dir, :margin, :gap, :trim, :rows, :columns])
      # EXTRACT METHOD HERE
      sheet_width = (p[:columns] * (@width + 2 * p[:gap] - 2 * p[:trim])) + (2 * p[:margin])
      sheet_height = (p[:rows] * (@height + 2 * p[:gap] - 2 * p[:trim])) + (2 * p[:margin])
      cc = Cairo::Context.new(Cairo::ImageSurface.new(sheet_width, sheet_height))
      num_this_sheet = 0
      sheet_num = 0
      x, y = p[:margin], p[:margin]
      @progress_bar.start("Saving PNG sheet to #{p[:dir]}/#{p[:prefix]}_*", @cards.size + 1) do |bar|
        p[:range].each do |i|
          if num_this_sheet >= (p[:columns] * p[:rows]) # new sheet
            filename = "#{p[:dir]}/#{p[:prefix]}#{p[:count_format] % sheet_num}.png"
            cc.target.write_to_png(filename)
            new_sheet = false
            num_this_sheet = 0
            sheet_num += 1
            x, y = p[:margin], p[:margin]
            cc = Cairo::Context.new(Cairo::ImageSurface.new(sheet_width, sheet_height))
          end
          surface = trim(@cards[i].cairo_surface, p[:trim], @width, @height)
          cc.set_source(surface, x, y)
          cc.paint
          bar.increment
          num_this_sheet += 1
          x += surface.width + p[:gap]
          if num_this_sheet % p[:columns] == 0 # new row
            x = p[:margin]
            y += surface.height + p[:gap]
          end
          bar.increment
        end
        cc.target.write_to_png("#{p[:dir]}/#{p[:prefix]}#{p[:count_format] % sheet_num}.png")
      end
    end

    # Return a new Cairo::ImageSurface that is trimmed from the original
    #
    # @param surface The surface to trim
    # @param trim The number of pixels around the edge to trim
    # @param width The width of the surface prior to the trim
    # @param height The height of the surface prior to the trim
    # :nodoc:
    # @api private
    def trim(surface, trim, width, height)
      if trim > 0
        tmp = Cairo::ImageSurface.new(width-2*trim, height-2*trim)
        cc = Cairo::Context.new(tmp)
        cc.set_source(surface,-1*trim, -1*trim)
        cc.paint
        surface = tmp
      end
      surface
    end

  end
end
