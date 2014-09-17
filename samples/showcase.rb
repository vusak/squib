require 'squib'

Squib::Deck.new(cards: 4) do
  background color: '#DED4B9'
  title = %w(Grifter Thief Thug Kingpin)
  text str: title, font: 'Helvetica,Sans weight=800 120', 
       x: 78, y: 78, width: 825-2*78, align: :center

  showcase file: 'showcase_output.png', trim: 78, trim_radius: 32
  
  #png file: 'pokercard.png', x:0, y:0, alpha: 0.5

  save_png prefix: 'showcase_'
end