require 'squib'

# Here's a handy list of game-related UTF-8 characters
# for those early pre-graphics prototypes
game_chars = %W(\u2620 \u2622 \u2623 \u00AB \u00BB \u2039 \u203A \u2022 \u20D8 \u20D9 \u20DA \u2023 \u20E1 \u20D4 \u20D5 \u20D6 \u20D7 \u2190 \u2191 \u2192 \u2193 \u2194 \u2196 \u2197 \u2198 \u2199 \u219A \u219B \u219C \u219D \u219E \u219F \u21A0 \u21A1 \u21A2 \u21A3 \u21A4 \u21A5 \u21A6 \u21A7 \u21A8 \u21A9 \u21AA \u21AB \u21AC \u21AD \u21AE \u21AF \u21B0 \u21B1 \u21B2 \u21B3 \u21B4 \u21B5 \u21B6 \u21B7 \u21B8 \u21B9 \u21BA \u21BB \u21C4 \u21C5 \u21C6 \u21C7 \u21C8 \u21C9 \u21CA \u21CD \u21CE \u21CF \u21D0 \u21D1 \u21D2 \u21D3 \u21D4 \u21D5 \u21D6 \u21D7 \u21D8 \u21D9 \u21DA \u21DB \u21DC \u21DD \u21DC \u21E0 \u21E1 \u21E2 \u21E3 \u21E4 \u21E5 \u21E6 \u21E7 \u21E8 \u21E9 \u21EA \u20DE \u20DD \u20DF \u20E0 \u2205 \u220E \u2234 \u2295 \u2296 \u2297 \u2298 \u2349 \u2299 \u229A \u229E \u22B9 \u2302 \u2316 \u231A \u231B \u2326 \u232B \u2327 \u2331 \u2460 \u2461 \u2462 \u2463 \u2464 \u2465 \u2466 \u2467 \u2468 \u2469 \u246A \u246B \u246C \u246D \u246E \u246F \u2470 \u2471 \u2472 \u2473 \u2600 \u2601 \u2602 \u2603 \u2604 \u2605 \u2606 \u2607 \u260E \u2611 \u261A \u261B \u261C \u261D \u261E \u261F \u2624 \u262E \u262F \u2639 \u263A \u2654 \u2655 \u2656 \u2657 \u2658 \u2659 \u265A \u265B \u265C \u265D \u265E \u265F \u2660 \u2661 \u2662 \u2663 \u2664 \u2665 \u2666 \u2667 \u2668 \u2690 \u2691 \u2692 \u2693 \u2694 \u2696 \u2699 \u269B \u26A0 \u26A1 \u26BD \u26BE \u26C4 \u26C5 \u26D4 \u26EA \u26F2 \u26F3 \u26F5 \u26FA \u26FD \u2707 \u270A \u270B \u270C \u2713 \u2714 \u271C \u27F2 \u27F3 \u27F4 \u2B1B \u2B1C \u1F601 \u00BD \u00BE \u00BC \u2153 \u2154 \u2155 \u2156 \u2157 )

cell_height = 80
cell_width = 400
cols = 7
x, y = 1, 80
Squib::Deck.new(height: (game_chars.size / cols + 1) * cell_height,
                width: cell_width * cols) do
  background color: :white
  text str: 'Game-related UTF8 icons. Generated by Squib, https://github.com/andymeneely/squib'
  game_chars.each_with_index do |c, i|
    rect fill_color: %w(#eeee #ffff)[i % 2],
         width: cell_width, height: cell_height,            x: x, y: y
    text str: c.inspect, font: 'Sans 42',                  x: x, y: y
    text str: c,         font: 'Sans,Segoe UI Symbol 42',  x: x + 300, y: y
    x += cell_width
    if i % cols == cols - 1
      x = 1
      y += cell_height if i % cols == cols - 1
    end
  end
  save_png prefix: 'unicode_'
end