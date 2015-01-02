require 'squib'

# A ruby implementation of this code snippet: http://lists.cairographics.org/archives/cairo/2013-November/024807.html
# Dim BBSrf As cCairoSurface, SCSrf As cCairoSurface
#
#    Set BBSrf = Cairo.CreateSurface(710, 620)
#    Set SCSrf = Cairo.CreateSurface(BBSrf.Width, BBSrf.Height)
#
#    New_c.Timing True
#
#      With BBSrf.CreateContext 'render the Text onto the BackBuf
#        .SetSourceColor vbBlack: .Paint 'clear BBSrf with Black
#
#        .SelectFont "Arial Black", 20, RGB(255, 222, 0), True
#        .DrawText 0, 50, BBSrf.Width, BBSrf.Height - 50, SB.ToString
#      End With
#
#      With SCSrf.CreateContext 'linewise-stretching into SCSrf
#        .SetSourceColor vbBlack: .Paint 'clear SCSrf with Black
#
#        Dim i As Double, Fac As Double
#        Do While i < SCSrf.Height
#          Fac = 0.35 + (i / SCSrf.Height * 0.7) ^ 2
#          .Save
#             .TranslateDrawings SCSrf.Width / 2 * (1 - Fac), 0
#             .ScaleDrawings Fac, Fac
#
#             .SetSourceSurface BBSrf
#             .Rectangle 0, i, SCSrf.Width, 4 'StripeHeight of 4
#             .Fill
#          .Restore
#          i = i + 1.5 'a StripeHeight-Shift-Relation of 1.5 / 4 works OK
#        Loop

#        SCSrf.FastBlur 'a fast Blur (optional, takes about 5msec here)
#      End With
#
#    Form.Caption = New_c.Timing 'visualize the timing in the caption
#
#    Cairo.ImageList.AddSurface "Test", SCSrf
#    Form.WidgetRoot.ImageKey = "Test"
# End Sub
Squib::Deck.new(cards: 1) do
  background color: :violet
  svg file: 'spanner.svg', width: 800, height: 800
  save_png prefix: 'striping-perspective'

  # Striping for faking out the perspective effect
  @cards[0].use_cairo do |srcCxt|
    src = srcCxt.target
    dest = Cairo::ImageSurface.new(825, 1125)
    destCxt = Cairo::Context.new(dest)
    destCxt.set_source_color(:gray)
    destCxt.paint

    # stripe_height = 4
    # stripe = 1.5
    # (0..src.height).step(stripe) do |i|
    #   factor = 0.35 + (i.to_f / src.height.to_f * 0.7)**1.5
    #   puts factor
    #   destCxt.save
    #   destCxt.translate src.width.to_f / 2.0 * (1.0-factor), 0
    #   destCxt.scale factor, factor
    #   destCxt.set_source(src, 0, 0)
    #   destCxt.rounded_rectangle(0, i, src.width, stripe_height, 0,0)
    #   destCxt.fill
    #   destCxt.restore
    # end

    # stripe_height = 4
    # stripe = 1.5
    # final_scale = 0.60
    # (0..src.height).step(stripe) do |i|
    #   factor = final_scale + (i / src.height.to_f * (1.0-final_scale)) #linear interpolation
    #   puts factor
    #   destCxt.save
    #   destCxt.translate src.width.to_f / 2.0 * (1.0-factor), 0
    #   destCxt.scale factor, factor
    #   destCxt.set_source(src, 0, 0)
    #   destCxt.rounded_rectangle(0, i, src.width, stripe_height, 0,0)
    #   destCxt.fill
    #   destCxt.restore
    # end

    # in_thickness = 1.5
    # final_scale = 0.5
    # out_thickness = 2 * in_thickness
    # (0..src.width).step(in_thickness) do |i|
    #   factor = final_scale + (i / src.width.to_f * (1.0 - final_scale)) #linear interpolation
    #   destCxt.save
    #   destCxt.translate 0, src.height.to_f / 2.0 * (1.0 - factor)
    #   destCxt.scale factor, factor
    #   destCxt.set_source src, 0, 0
    #   destCxt.rounded_rectangle i, 0, out_thickness, src.height, 0,0
    #   destCxt.fill
    #   destCxt.restore
    # end
    # dest.write_to_png('_output/striping-perspective_2.png')
    # final_dest = Cairo::ImageSurface.new(825 * final_scale, 1125)
    # final_destCxt = Cairo::Context.new(final_dest)
    # final_destCxt.set_source_color(:gray)
    # final_destCxt.paint
    # final_destCxt.scale final_scale, 1.0
    # final_destCxt.set_source dest, 0, 0
    # final_destCxt.paint
    # final_dest.write_to_png('_output/striping-perspective_3.png')

    in_thickness = 1
    final_scale = 0.8
    out_thickness = 3 * in_thickness
    dest = Cairo::ImageSurface.new(825 * final_scale, 1125)
    destCxt = Cairo::Context.new(dest)
    destCxt.set_source_color(:gray)
    destCxt.paint
    (0..src.width).step(in_thickness) do |i|
      percentage = i / src.width.to_f
      puts "#{percentage * 100.0}%"
      factor = final_scale + (percentage * (1.0 - final_scale)) #linear interpolation
      destCxt.save
      destCxt.translate 0, src.height.to_f / 2.0 * (1.0 - factor)
      destCxt.scale factor * final_scale, factor
      destCxt.set_source src, 0, 0
      destCxt.rounded_rectangle i, 0, out_thickness, src.height, 0,0
      destCxt.fill
      destCxt.restore
    end
    dest.write_to_png('_output/striping-perspective_4.png')
  end
end