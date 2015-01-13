require 'squib'

Squib::Deck.new(cards: 4, layout: 'layout.yml') do
  background color: '#230602'
  deck = xlsx file: 'bigger.xlsx'

  text str: deck['Title'], layout: :Title

  svg file: 'attack.svg', layout: :AttackIcon
  text str: deck['Attack'], layout: :AttackText

  svg file: 'defend.svg', layout: :DefendIcon
  text str: deck['Defend'], layout: :DefendText

  save_png prefix: 'bigger_'
end
