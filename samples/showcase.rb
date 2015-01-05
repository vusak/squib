require 'squib'

# Showcases are a neat way to show off your cards in a modern way, using a
# reflection and a persepctive effect to make them look 3D
Squib::Deck.new(cards: 4) do
  background color: '#CE534D'
  rect fill_color: '#DED4B9', x: 78, y: 78,
       width: '2.25in', height: '3.25in', radius: 32
  text str: %w(Grifter Thief Thug Kingpin),
       font: 'Helvetica,Sans weight=800 120',
       x: 78, y: 78, width: '2.25in', align: :center
  svg file: 'spanner.svg', x: (825-500)/2, y: 500, width: 500, height: 500

  # Here's a more complete example
  showcase trim: 32, trim_radius: 32,
           scale: 0.85, offset: 1.05, fill_color: :white,
           file: 'showcase_output.png'
  save_png prefix: 'showcase_' # to show that they're not trimmed
end