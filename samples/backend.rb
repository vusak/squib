require 'squib'

Squib::Deck.new(config: 'backend-config.yml') do
  background color: :white

  text str: "Hello, world!", x: 0, y: 500, width: 825,
       font: 'Sans bold 120', align: :center

  save prefix: 'backend_', format: :pdf
end
