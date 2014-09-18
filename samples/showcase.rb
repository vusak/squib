require 'squib'

Squib::Deck.new(cards: 4) do
  background color: '#CE534D'
  rect fill_color: '#DED4B9', x: 78, y: 78, 
       width: 825-2*78, height: 1125-2*78, radius: 32
  title = %w(Grifter Thief Thug Kingpin)
  text str: title, font: 'Helvetica,Sans weight=800 120', 
       x: 78, y: 78, width: 825-2*78, align: :center
  svg file: 'spanner.svg', x: (825-500)/2, y: 500, width: 500, height: 500

  showcase file: 'showcase_output.png', trim: 78, trim_radius: 32
  
  #png file: 'pokercard.png', x:0, y:0, alpha: 0.5

  save_png prefix: 'showcase_'
end