require 'squib'

Squib::Deck.new(config: 'backend-config.yml') do
  background color: :white

  text str: "Hello, world!", x: 0, y: 500, width: 825,
       font: 'Sans bold 72', align: :center

  save_png prefix: 'backend_'
  save_pdf file: 'backend.pdf'
end
