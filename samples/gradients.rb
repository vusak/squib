require 'squib'

Squib::Deck.new do
  # Just about anywhere Squib takes in a color it can also take in a gradient too
  # Note that we need to provide xy coordinates.
  # These are relative to the xy provided the command.
  background color: '(0,0)(0,1125) #ccc@0.0 #111@1.0'

  # Radial gradients look like this
  circle  x: 415, y: 415, radius: 100, stroke_color: '#0000',
          fill_color: '(425,400,2)(425,400,120) #ccc@0.0 #111@1.0'

  save_png prefix: 'gradient_'
end