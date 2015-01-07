require 'cairo'
require 'squib/input_helpers'
require 'squib/tmp_maker'

module Squib
  # Back end graphics. Private.
  class Card
    include Squib::InputHelpers

    # :nodoc:
    # @api private
    attr_reader :width, :height

    # :nodoc:
    # @api private
    attr_accessor :cairo_surface, :cairo_context

    # :nodoc:
    # @api private
    def initialize(deck, width, height, backend='memory')
      @deck=deck; @width=width; @height=height
      @cairo_surface = create_backend(width, height, backend)
      @cairo_context = Cairo::Context.new(@cairo_surface)
    end

    def create_backend(width, height, backend)
      case backend
      when 'memory'
        Cairo::ImageSurface.new(width, height)
      when 'svg'
        Cairo::SVGSurface.new(Squib::TmpMaker.next, width, height)
      else
        Squib.logger.fatal "Back end not recognized: '#{backend}'"
        abort
      end
    end

  # A save/restore wrapper for using Cairo
  # :nodoc:
  # @api private
    def use_cairo(&block)
      @cairo_context.save
      block.yield(@cairo_context)
      @cairo_context.restore
    end

    ########################
    ### BACKEND GRAPHICS ###
    ########################
    require 'squib/graphics/background'
    require 'squib/graphics/image'
    require 'squib/graphics/save_doc'
    require 'squib/graphics/save_images'
    require 'squib/graphics/shapes'
    require 'squib/graphics/showcase'
    require 'squib/graphics/text'

  end
end
