require 'squib'

light = '#F3EFE3'
dark = '#230602'
Squib::Deck.new(cards: 2, width: 825, height: 1125) do
  background color: dark

  text str: %w( Attack Defend ),
       color: light, font: 'ChunkFive Roman,Sans 72',
       y: '2.5in', width: '2.75in', align: :center

  svg file: %w(attack.svg shield.svg),
      width: 500, height: 500,
      x: 150, y: 250 # icons adapted from game-icons.net

  save_png dir: '.', prefix: 'better_'
end
