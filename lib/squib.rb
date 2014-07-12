require 'squib/graphics/text'
require 'squib/graphics/save'
require 'squib/deck'
require 'squib/card'
require 'singleton'

module Squib
  @@the_deck = nil

  def self.the_deck=(d)
    @@the_deck = d 
  end

  def self.the_deck
    @@the_deck 
  end
end

##################
### PUBLIC API ###
##################

def deck(width: , height: , cards: 1)
  Squib::the_deck = Squib::Deck.new(width, height, cards)
end

def font(type: , size: 12, **options)
end

def set_font(type: 'Arial', size: 12, **options)
	Squib::queue_command Squib::Graphics::SetFont.new(type,size,options)
end

def text(range=:all, str: , font: :use_set, x: 0, y: 0, **options)
  deck = Squib::the_deck
  range = 0..(deck.num_cards-1) if range == :all
  str = [str] * deck.num_cards unless str.respond_to? :each
  range.each do |i|
    Squib::Graphics::Text.new(deck[i], str[i], font, x, y, options).execute
  end
end

def image(range=:all, file: , x: 0, y: 0)
end

def rect(x:, y:, width:, height:, x_radius: 0, y_radius: 0)

end

def load_csv(file:, header: true)
end

def data(field)
end

def save(format: :png)
  Squib::Graphics::Save.new(format).execute
end