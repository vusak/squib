module Squib
  class Deck

    # Ported from: http://kapo-cpp.blogspot.com/2008/01/perspective-effect-using-cairo.html
    # This was also helpful: http://zetcode.com/gui/pygtk/drawingII/
    # // Set matrix for reflection
    # Cairo::Matrix matrix_reflex;
    # cairo_matrix_init (&matrix_reflex,
    #     0.5, 0.25,
    #     0.0, -1.0,
    #     0.0, image_ptr_->get_height() * 2);    
    # context->transform (matrix_reflex);
    #
    # // Prepare mask
    # Gdk::Color shadow_color( "black" );
    #
    # Cairo::RefPtr< Cairo::LinearGradient > mask_gradient_ptr = Cairo::LinearGradient::create (
    #     image_ptr_->get_width() / 2, image_ptr_->get_height() / 2, 
    #     image_ptr_->get_width() / 2, image_ptr_->get_height());
    #
    # mask_gradient_ptr->add_color_stop_rgba (0, 
    #         shadow_color.get_red_p(), shadow_color.get_green_p(), shadow_color.get_blue_p(), 0.0);
    #
    # mask_gradient_ptr->add_color_stop_rgba (1, 
    #         shadow_color.get_red_p(), shadow_color.get_green_p(), shadow_color.get_blue_p(), 0.5);
    #
    # // Draw the reflex
    # context->set_source (image_surface_ptr_, 0.0, 0.0);
    # context->mask (mask_gradient_ptr);

    # Actually render the showcase
    # :nodoc:
    # @api private
    def render_showcase(range, trim, trim_radius, dir, file_to_save)

      angle = 0.12
      scale = 0.85
      offset = 0.95
      fill_color = :white

      out_width = range.size * (@width + 50)
      out_height = @height * (2 + scale + angle)
      out_cc = Cairo::Context.new(Cairo::ImageSurface.new(out_width, out_height))

      out_cc.set_source_color(fill_color)
      out_cc.paint

      cards = range.collect { |i| @cards[i] }

      cards.each_with_index do |card, i|
        surface = perspective_reflect(trim(card.cairo_surface), angle, scale)
        out_cc.set_source(surface, 25 + i * (surface.width*offset + 25) ,75)
        out_cc.paint
      end

      out_cc.target.write_to_png("#{dir}/#{file_to_save}.png")
    end

    def trim(surface)
      margin = 39
      radius = 32
      trim_cc = Cairo::Context.new(Cairo::ImageSurface.new(surface.width-2.0*margin, surface.height-2.0*margin))
      trim_cc.rounded_rectangle(0, 0, trim_cc.target.width, trim_cc.target.height, radius, radius)
      trim_cc.set_source(surface, -1 * margin, -1 * margin)
      trim_cc.clip
      trim_cc.paint
      return trim_cc.target
    end

    def perspective_reflect(surface, angle, scale)
      tmp_cc = Cairo::Context.new(Cairo::ImageSurface.new(surface.width * (scale+angle/2), surface.height * (2 + angle/2.0)))

      #### TOP PART ####
      scale_x     = scale      # scale the width
      scale_y     = 1.0        # same height, not reversed
      rotate_x    = 0.0        # 
      rotate_y    = -1 * angle # don't rotate along y
      translate_x = 0.0        # don't translate x
      translate_y = 225 # make room for our top-right corner
      matrix = Cairo::Matrix.new(scale_x, rotate_y, 
                                 rotate_x, scale_y, 
                                 translate_x, translate_y)
      tmp_cc.transform(matrix)
      tmp_cc.set_source(surface,0,0)
      
      tmp_cc.paint

      tmp_cc.identity_matrix #reset
      tmp_cc.new_path

      #### BOTTOM PART ####

      # Transformation
      scale_x     = scale       # scale the width
      scale_y     = -1.0  # same height, but reversed
      rotate_x    = 0.0         # 
      rotate_y    = -1 * angle  # don't rotate along y
      translate_x = 0.0         # don't translate
      translate_y = surface.height * 2 + 250
      matrix = Cairo::Matrix.new(scale_x, rotate_y, 
                                 rotate_x, scale_y, 
                                 translate_x, translate_y)
      tmp_cc.transform(matrix)
      tmp_cc.set_source(surface,0,0)

      # Gradient mask
      gradient = Cairo::LinearPattern.new(0.0, 0.0, 0.0, 2000)
      gradient.add_color_stop_rgba(0,   0,0,0, 0.0)
      gradient.add_color_stop_rgba(1.0, 0,0,0, 0.3)
      # tmp_cc.set_source(gradient)
      # tmp_cc.paint
      # tmp_cc.clip
      tmp_cc.mask(gradient)

      # tmp_cc.paint

      return tmp_cc.target
    end

  end  
end